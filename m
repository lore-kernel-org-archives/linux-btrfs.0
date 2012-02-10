From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Thu, 9 Feb 2012 20:32:18 -0500
Message-ID: <20120210013218.GB8384@shiny>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
 <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
 <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com>
 <20120208125536.GI16796@shiny>
 <CAAE6i0ggEyVGh94L7n00Mm-YZTq26de2kZspU+AQKiaA=JD+8g@mail.gmail.com>
 <20120208202658.GH8384@shiny>
 <CAAE6i0hWxsSKLoN8zyJv9H4tu5R5B3KXvbgZzHDcMHYC4JX3mA@mail.gmail.com>
 <CAAE6i0isDwiA_vyg=KX_sodu7gyux7wJhEM5OXjD=4jgRqwj+g@mail.gmail.com>
 <CAAE6i0h+E0vQ4D6gr7MQiwS00hnQGk5R7ubkRa00NdkoaNxcNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0h+E0vQ4D6gr7MQiwS00hnQGk5R7ubkRa00NdkoaNxcNA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 09, 2012 at 06:54:42PM -0600, Chester wrote:
> Output for btrfs-debug-tree for that specific block in dmesg
> 
> And available here ( http://pastebin.com/AgdvS5JM ) in case the lines
> wrap and look ugly

Ok, good news.  This bad block is in the extent allocation tree, which
means it is easy to replace.

Is it possible for you to make a block level backup of this disk?  That
way we can experiment a little and fix it up.

Either way, I'll recreate this corruption here in the morning and patch
fsck to fix it.

-chris
