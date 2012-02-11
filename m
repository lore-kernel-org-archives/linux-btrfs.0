From: Chester <somethingsome2000@gmail.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Sat, 11 Feb 2012 15:42:12 -0600
Message-ID: <CAAE6i0g3T-0EOoxGYJAde3rQY53QvwhAtHwSgZ-VPd1sTpgkjg@mail.gmail.com>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
 <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
 <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com>
 <20120208125536.GI16796@shiny> <CAAE6i0ggEyVGh94L7n00Mm-YZTq26de2kZspU+AQKiaA=JD+8g@mail.gmail.com>
 <20120208202658.GH8384@shiny> <CAAE6i0hWxsSKLoN8zyJv9H4tu5R5B3KXvbgZzHDcMHYC4JX3mA@mail.gmail.com>
 <CAAE6i0isDwiA_vyg=KX_sodu7gyux7wJhEM5OXjD=4jgRqwj+g@mail.gmail.com>
 <CAAE6i0h+E0vQ4D6gr7MQiwS00hnQGk5R7ubkRa00NdkoaNxcNA@mail.gmail.com> <20120210212749.GR8384@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Chester <somethingsome2000@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120210212749.GR8384@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2012 at 3:27 PM, Chris Mason <chris.mason@oracle.com> w=
rote:

>
> Ok, its worth pointing out that you're just one bit away from proper
> ordering here. =A0While I'm testing out this code to fix key ordering=
,
> could you please run memtest86 on your machine?
>

I ran memtest for a good 16 hours and it has passed 8 times without any=
 errors.

> The other fields all look correct.
>
> -chris
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
