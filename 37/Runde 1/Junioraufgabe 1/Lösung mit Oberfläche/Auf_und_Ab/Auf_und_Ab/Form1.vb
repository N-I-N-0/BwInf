Public Class Form1
    Dim fields() As Integer
    Dim ladders() As Integer
    Dim startOfLoop As Integer

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        If Not TextBox3.Text = "" And Not TextBox3.Enabled = False Then
            TextBox3.Enabled = False
            Button1.Enabled = True
            Button3.Enabled = True
            ReDim fields(Val(TextBox3.Text))
            ReDim ladders(Val(TextBox3.Text))
            For i As Integer = 0 To Val(TextBox3.Text)
                fields(i) = 0
                ladders(i) = 0
            Next
        End If
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Dim newItem = TextBox1.Text + "," + TextBox2.Text
        ListBox1.Items.Add(newItem)
        TextBox1.Text = ""
        TextBox2.Text = ""
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        If Not TextBox3.Text = "" Or TextBox2.Text = "" Or TextBox3.Enabled = True Then
            ReDim fields(Val(TextBox3.Text))
            ReDim ladders(Val(TextBox3.Text))
            For i As Integer = 0 To Val(TextBox3.Text)
                fields(i) = 0
                ladders(i) = 0
            Next
            Button1.Enabled = False
            Set_Ladders()
            Start_Test()
            TextBox3.Enabled = True
            Button3.Enabled = False
        End If
    End Sub

    Public Sub Set_Ladders()
        For i As Integer = 0 To ListBox1.Items.Count - 1
            Dim currentLadder = ListBox1.Items.Item(i).ToString.Split(",")
            ladders(Val(currentLadder(0))) = Val(currentLadder(1))
            ladders(Val(currentLadder(1))) = Val(currentLadder(0))
        Next
    End Sub

    Public Sub Start_Test()
        Dim currentField As Integer = 0
        Dim diceNumber As Integer = Val(TextBox4.Text)
        Dim stepsCount = 0
        TextBox5.Text += "Zurückgelegte Felder: "
        Do While currentField < Val(TextBox3.Text) And Reachable(currentField)
            If Not ladders(currentField) = 0 Then
                currentField = ladders(currentField)
            End If
            stepsCount += 1
            TextBox5.Text += currentField.ToString + " "
            currentField += diceNumber
            currentField = Go_Back(currentField)
        Loop
        If currentField = Val(TextBox3.Text) Then
            TextBox5.Text += "100" + vbNewLine + "Mit der Würfelzahl " + diceNumber.ToString + " muss man " + stepsCount.ToString + " mal würfeln, um das Ziel zu erreichen!" + vbNewLine
        Else
            TextBox5.Text += vbNewLine + "Nur mit der Würfelzahl " + diceNumber.ToString + " scheint es nicht möglich zu sein das Ziel zu erreichen. Spätestens nach " + stepsCount.ToString + " Schritten, ab Feld " + currentField.ToString + ", läuft man in einer Schleife!" + vbNewLine
        End If
    End Sub

    Public Function Reachable(currentField As Integer)
        If fields(currentField) < 2 Then
            fields(currentField) += 1
            Return True
        Else
            startOfLoop = currentField
            Return False
        End If
    End Function

    Public Function Go_Back(currentField As Integer)
        If currentField > Val(TextBox3.Text) Then
            currentField -= Val(TextBox3.Text)
            currentField = Val(TextBox3.Text) - currentField
        End If
        Return currentField
    End Function

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        ListBox1.Items.Remove(ListBox1.SelectedItem)
    End Sub

    Private Sub PictureBox1_Click(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Process.Start("https://bwinf.de/fileadmin/user_upload/BwInf/2018/37/1._Runde/Material/leiterspiel.pdf")
    End Sub
End Class