Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-hk2apc01on0053.outbound.protection.outlook.com ([104.47.124.53]:36576
	"EHLO APC01-HK2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751821AbcETDTQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 23:19:16 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Graham Cobb <g.btrfs@cobb.uk.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [Not TLS] Re: Reducing impact of periodic btrfs balance
Date: Fri, 20 May 2016 03:19:10 +0000
Message-ID: <SYXPR01MB0367B32A4679BFB74B546A4A9E4B0@SYXPR01MB0367.ausprd01.prod.outlook.com>
References: <573C6E47.2080109@cobb.uk.net>
 <d40d8fc7-3766-1ccc-3253-9f870a0f4f85@cn.fujitsu.com>
 <pan$549b5$526f9b98$5d8778de$5121c19f@cox.net> <573D914F.8000305@cobb.uk.net>
In-Reply-To: <573D914F.8000305@cobb.uk.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Graham Cobb
> Sent: Thursday, 19 May 2016 8:11 PM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: [Not TLS] Re: Reducing impact of periodic btrfs balance
> 
> On 19/05/16 05:09, Duncan wrote:
> > So to Graham, are these 1.5K snapshots all of the same subvolume, or
> > split into snapshots of several subvolumes?  If it's all of the same
> > subvolume or of only 2-3 subvolumes, you still have some work to do in
> > terms of getting down to recommended snapshot levels.  Also, if you
> > have quotas on and don't specifically need them, try turning them off
> > and see if that alone makes it workable.
> 
> I have just under 20 subvolumes but the snapshots are only taken if
> something has changed (actually I use btrbk: I am not sure if it takes the
> snapshot and then removes it if nothing changed or whether it knows not to
> even take it).  The most frequently changing subvolumes have just under 400
> snapshots each.  I have played with snapshot retention and think it unlikely I
> would want to reduce it further.
> 
> I have quotas turned off.  At least, I am not using quotas -- how can I double
> check it is really turned off?
> 
> I know that very large numbers of snapshots are not recommended, and I
> expected the balance to be slow.  I was quite prepared for it to take many
> days.  My full backups take several days and even incrementals take several
> hours. What I did not expect, and think is a MUCH more serious problem, is
> that the balance prevented use of the disk, holding up all writes to the disk
> for (quite literally) hours each.  I have not seen that effect mentioned
> anywhere!
> 
> That means that for a large, busy data disk, it is impossible to do a balance
> unless the server is taken down to single-user mode for the time the balance
> takes (presumably still days).  I assume this would also apply to doing a RAID
> rebuild (I am not using multiple disks at the moment).
> 
> At the moment I am still using my previous backup strategy, alongside the
> snapshots (that is: rsync-based rsnapshots to another disk daily and with
> fairly long retentions, and separate daily full/incremental backups using dar
> to a nas in another building).  I was hoping the btrfs snapshots might replace
> the daily rsync snapshots but it doesn't look like that will work out.

I do a similar thing - on my main fs I have only minimal snapshots - like less than 10. I rsync (with checksumming off and diff copy on) the fs to the backup fs which is where all the snapshots live. That fs only gets the occasional 20% balance when it runs out of space, and weekly scrubs. Performance doesn't seem to suffer that way.

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
