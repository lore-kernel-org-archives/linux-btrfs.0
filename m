From: Hugo Chevrain <hugochevrain@gmail.com>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Date: Tue, 24 Jan 2012 17:03:16 +0000 (UTC)
Message-ID: <loom.20120124T180109-491@post.gmane.org>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <20120117090746.GD7322@twin.jikos.cz> <loom.20120118T155934-197@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> evergreen writes:
> > 
> 
> Although there is LessFS's Mark Ruijter :
> http://www.lessfs.com/wordpress/?p=684&cpage=1#comment-3114
> 
> "On average the speeds appear to be 48% faster then snappy."
> Sounds promising...
> 
> --

Well, it seems that the performance is really good.
Apparently, LZ4 has displaced Snappy as speed champion for LessFS.

http://www.lessfs.com/wordpress/?p=688



