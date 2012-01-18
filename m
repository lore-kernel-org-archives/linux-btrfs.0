From: evergreen <Kdo4971@hotmail.com>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Date: Wed, 18 Jan 2012 15:02:48 +0000 (UTC)
Message-ID: <loom.20120118T155934-197@post.gmane.org>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <20120117090746.GD7322@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> it has comparable performance and compression ratio to snappy. Quoting
> from the source repo main page:
> 
> Name            Ratio   C.speed D.speed
> LZ4 (r41)       2.08    319     1070
> LZO 2.05 1x_1   2.07    318      466
> Snappy 1.0.4    2.02    242      683
> 


Although there is LessFS's Mark Ruijter :
http://www.lessfs.com/wordpress/?p=684&cpage=1#comment-3114

"On average the speeds appear to be 48% faster then snappy."
Sounds promising...


