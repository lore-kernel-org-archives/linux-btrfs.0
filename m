From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Fri, 10 Feb 2012 16:27:49 -0500
Message-ID: <20120210212749.GR8384@shiny>
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
> 
> leaf 653297209344 items 43 free space 673 generation 332442 owner 2
> fs uuid 0f5b2f4f-1aa0-4e6f-b904-e5b4d4588144
> chunk uuid 27536f0d-993b-4da3-85eb-1c9b08c435cb
> 	item 7 key (653284831232 EXTENT_ITEM 4096) itemoff 3551 itemsize 51
> 		extent refs 1 gen 332218 flags 2
> 		tree block key (654686961664 a8 4096) level 0
> 		tree block backref root 2
> 	item 8 key (653284818944 EXTENT_ITEM 4096) itemoff 3500 itemsize 51
> 		extent refs 1 gen 332218 flags 2
> 		tree block key (654687121408 a8 4096) level 0
> 		tree block backref root 2

Ok, its worth pointing out that you're just one bit away from proper
ordering here.  While I'm testing out this code to fix key ordering,
could you please run memtest86 on your machine?

The other fields all look correct.

-chris

