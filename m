Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48293 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbaLAGZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 01:25:35 -0500
Message-ID: <547C09DC.9080803@cn.fujitsu.com>
Date: Mon, 1 Dec 2014 14:25:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com>	<pan$d4d18$d4463d$8df93dd7$d770703b@cox.net>	<547BDF82.3030305@cn.fujitsu.com> <pan$6be5e$a00482b7$895022c1$577dcbfa@cox.net>
In-Reply-To: <pan$6be5e$a00482b7$895022c1$577dcbfa@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
From: Duncan <1i5t5.duncan@cox.net>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年12月01日 13:47
> Qu Wenruo posted on Mon, 01 Dec 2014 11:24:50 +0800 as excerpted:
>
>> The db file is mostly used in memory, only when the metadata is really
>> really big, maybe when the fs tree's level is 7 or 8 we may need to use
>> db file.
> So fscking the database in ordered to fsck the database isn't an issue.
> One objection down! =:^)
>
> But seriously, the politics of the idea remains its biggest nemesis in my
> opinion.  And in systemd we've unfortunately a live demonstration of just
> how big a nemesis that can be.  =:^(  If the technical reasoning for it
> is sound and the benefit high enough, great, but IMO the benefit will
> need to be pretty high to justify the risk of political fallout, and I
> doubt it's anything close to that high.  But it's not my call, so we'll
> see.  Thinks could certainly get interesting if it's judged to be worth
> it.  < Checking popcorn stash >
>
No (systemd civilian) war, make love!

I seldom consider the politics problem of the insane idea even the 
systemd warfare is still here.
(Emmm, maybe it is because Arch accept systemd too long time ago without 
too much problem?)

Anyway, it is just an insane idea and any feedback killing the seed of 
insanity as soon as possible is welcomed.

Thanks,
Qu
