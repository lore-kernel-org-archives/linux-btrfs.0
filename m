From: Chester <somethingsome2000@gmail.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Fri, 30 Mar 2012 21:32:25 -0500
Message-ID: <CAAE6i0h+oV4pD2encrO_X0APLhAZSsDWTYC=KScyE-zBOs+SxA@mail.gmail.com>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
 <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
 <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com>
 <20120208125536.GI16796@shiny> <CAAE6i0ggEyVGh94L7n00Mm-YZTq26de2kZspU+AQKiaA=JD+8g@mail.gmail.com>
 <20120208202658.GH8384@shiny> <CAAE6i0hWxsSKLoN8zyJv9H4tu5R5B3KXvbgZzHDcMHYC4JX3mA@mail.gmail.com>
 <CAAE6i0isDwiA_vyg=KX_sodu7gyux7wJhEM5OXjD=4jgRqwj+g@mail.gmail.com>
 <CAAE6i0h+E0vQ4D6gr7MQiwS00hnQGk5R7ubkRa00NdkoaNxcNA@mail.gmail.com>
 <20120210212749.GR8384@shiny> <CAAE6i0g3T-0EOoxGYJAde3rQY53QvwhAtHwSgZ-VPd1sTpgkjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Chester <somethingsome2000@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0g3T-0EOoxGYJAde3rQY53QvwhAtHwSgZ-VPd1sTpgkjg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
I don't know if you still have this email thread saved in your email
client but, I'm the guy with the bad key ordering. Something about a
bad block in extent allocation tree (just one bit off).

I noticed that that your merged your dangerdonteveruse branch
recently. Just wondering if this problem is fixable now (or maybe the
new kernel can handle it without fsck?)

If you no longer have the original email with the debug info, here's a link:
http://www.spinics.net/lists/linux-btrfs/msg14930.html

Thanks.
