Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57031 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473AbcCaU2H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 16:28:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aljCC-0006sQ-9A
	for linux-btrfs@vger.kernel.org; Thu, 31 Mar 2016 22:28:00 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 22:28:00 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 22:28:00 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bad metadata crossing stripe boundary
Date: Thu, 31 Mar 2016 22:27:51 +0200
Message-ID: <20160331222751.0585f1a7@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
	<56F7E65C.7020300@gmx.com>
	<20160328120203.1b8d79dc@jupiter.sol.kaishome.de>
	<56FC7E6D.8010805@cn.fujitsu.com>
	<56FC8C15.5060002@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 31 Mar 2016 10:31:49 +0800
schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:

> Qu Wenruo wrote on 2016/03/31 09:33 +0800:
> >
> >
> > Kai Krakow wrote on 2016/03/28 12:02 +0200:  
> >> Changing subject to reflect the current topic...
> >>
> >> Am Sun, 27 Mar 2016 21:55:40 +0800
> >> schrieb Qu Wenruo <quwenruo.btrfs@gmx.com>:
> >>  
>  [...]  
>  [...]  
> >>
> >> No, btrfs-progs 4.5 reports those, too (as far as I understood,
> >> this includes the fixes for bogus "bad metadata" errors, tho I
> >> thought this has already been fixed in 4.2.1, I used 4.4.1). There
> >> were some nbytes wrong errors before which I already repaired
> >> using "--repair". I think that's okay, I had those in the past and
> >> it looks like btrfsck can repair those now (and I don't have to
> >> delete and recreate the files). It caused problems with "du" and
> >> "df" in the past, a problem that I'm currently facing too. So I
> >> better fixed them.
> >>
> >> With that done, the backup fs now only reports "bad metadata" which
> >> have been there before space cache v2. Full output below.
> >>  
>  [...]  
>  [...]  
> >>
> >> Copy and paste problem. Claws mail pretends to be smarter than me
> >> - I missed to fix that one. ;-)  
> >
> > I was searching for the missing '\n' and hopes to find any chance to
> > submit a new patch.
> > What a pity. :(
> >  
> >>  
>  [...]  
> >>
> >> Helped, it automatically reverted the FS back to space cache v1
> >> with incompat flag cleared. (I wouldn't have enabled v2 if it
> >> wasn't documented that this is possible)
> >>  
>  [...]  
>  [...]  
> >>
> >> It's gone now, ignore that. It's back to the situation before space
> >> cache v2. Minus some "nbytes wrong" errors I had and fixed.  
> >
> > Nice to see it works.
> >  
> >>
> >> Nevertheless, I'm now using btrfs-progs 4.5. Here's the full
> >> output: (the lines seem to be partly out of order, probably due to
> >> the redirection)
> >>
> >> $ sudo btrfsck /dev/sde1 2>&1 | tee btrfsck-label-usb-backup.txt
> >> checking extents
> >> bad metadata [156041216, 156057600) crossing stripe boundary
> >> bad metadata [181403648, 181420032) crossing stripe boundary
> >> bad metadata [392167424, 392183808) crossing stripe boundary
> >> bad metadata [783482880, 783499264) crossing stripe boundary
> >> bad metadata [784924672, 784941056) crossing stripe boundary
> >> bad metadata [130151612416, 130151628800) crossing stripe boundary
> >> bad metadata [162826813440, 162826829824) crossing stripe boundary
> >> bad metadata [162927083520, 162927099904) crossing stripe boundary
> >> bad metadata [619740659712, 619740676096) crossing stripe boundary
> >> bad metadata [619781947392, 619781963776) crossing stripe boundary
> >> bad metadata [619795644416, 619795660800) crossing stripe boundary
> >> bad metadata [619816091648, 619816108032) crossing stripe boundary
> >> bad metadata [620011388928, 620011405312) crossing stripe boundary
> >> bad metadata [890992459776, 890992476160) crossing stripe boundary
> >> bad metadata [891022737408, 891022753792) crossing stripe boundary
> >> bad metadata [891101773824, 891101790208) crossing stripe boundary
> >> bad metadata [891301199872, 891301216256) crossing stripe boundary
> >> bad metadata [1012219314176, 1012219330560) crossing stripe
> >> boundary bad metadata [1017202409472, 1017202425856) crossing
> >> stripe boundary bad metadata [1017365397504, 1017365413888)
> >> crossing stripe boundary bad metadata [1020764422144,
> >> 1020764438528) crossing stripe boundary bad metadata
> >> [1251103342592, 1251103358976) crossing stripe boundary bad
> >> metadata [1251145809920, 1251145826304) crossing stripe boundary
> >> bad metadata [1251147055104, 1251147071488) crossing stripe
> >> boundary bad metadata [1259271225344, 1259271241728) crossing
> >> stripe boundary bad metadata [1266223611904, 1266223628288)
> >> crossing stripe boundary bad metadata [1304750063616,
> >> 1304750080000) crossing stripe boundary bad metadata
> >> [1304790106112, 1304790122496) crossing stripe boundary bad
> >> metadata [1304850792448, 1304850808832) crossing stripe boundary
> >> bad metadata [1304869928960, 1304869945344) crossing stripe
> >> boundary bad metadata [1305089540096, 1305089556480) crossing
> >> stripe boundary bad metadata [1309581443072, 1309581459456)
> >> crossing stripe boundary bad metadata [1309583671296,
> >> 1309583687680) crossing stripe boundary bad metadata
> >> [1309942808576, 1309942824960) crossing stripe boundary bad
> >> metadata [1310050549760, 1310050566144) crossing stripe boundary
> >> bad metadata [1313031585792, 1313031602176) crossing stripe
> >> boundary bad metadata [1313232912384, 1313232928768) crossing
> >> stripe boundary bad metadata [1555210764288, 1555210780672)
> >> crossing stripe boundary bad metadata [1555395182592,
> >> 1555395198976) crossing stripe boundary bad metadata
> >> [2050576744448, 2050576760832) crossing stripe boundary bad
> >> metadata [2050803957760, 2050803974144) crossing stripe boundary
> >> bad metadata [2050969108480, 2050969124864) crossing stripe
> >> boundary checking free space cache checking fs roots checking
> >> csums checking root refs Checking filesystem on /dev/sde1 UUID:
> >> 1318ec21-c421-4e36-a44a-7be3d41f9c3f found 1860212384661 bytes
> >> used err is 0 total csum bytes: 1805105124
> >> total tree bytes: 11788713984
> >> total fs tree bytes: 8220835840
> >> total extent tree bytes: 1443282944
> >> btree space waste bytes: 2306453698
> >> file data blocks allocated: 2137152151552
> >>   referenced 2706831974400
> >>
> >> That drive was not converted so either "bad metadata" is still a
> >> false alert or there is something else going wrong in btrfs.
> >>  
> > It seems to be a false alert.
> >
> > Just pick the last [2050969108480, 2050969124864) as an example,
> > In fact, they are inside the same 64K block:
> > 2050969108480 / 64K == (2050969124864 - 1) / 64K == 31295305.
> >
> > I'd better double check the codes to fix the false alert before more
> > such report.
> >
> > Thanks,
> > Qu
> >  
> 
> Would you please try the following patch based on v4.5 btrfs-progs?
> https://patchwork.kernel.org/patch/8706891/
> 
> According to your output, all the output is false alert.
> All the extent starting bytenr can be divided by 64K, and I think at 
> initial time, its 'max_size' may be set to 0, causing "start + 0 - 1"
> to be inside previous 64K range.
> 
> The patch would update cross_stripe every time the extent is updated,
> so such temporary false alert should disappear.

Applied and no more reports of crossing stripe boundary - thanks.

Will this go into 4.5.1 or 4.5.2?

-- 
Regards,
Kai

Replies to list-only preferred.

