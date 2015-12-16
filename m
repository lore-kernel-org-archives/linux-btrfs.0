Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17205 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784AbbLPBxk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 20:53:40 -0500
Date: Tue, 15 Dec 2015 17:53:14 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Martin Steigerwald <martin@lichtvoll.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Still not production ready
Message-ID: <20151216015313.GB11024@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <8336788.myI8ELqtIK@merkaba>
 <566E2490.8080905@cn.fujitsu.com>
 <20151215215958.GC6322@ret.masoncoding.com>
 <5670BC6D.1010906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5670BC6D.1010906@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 16, 2015 at 09:20:45AM +0800, Qu Wenruo wrote:
> 
> 
> Chris Mason wrote on 2015/12/15 16:59 -0500:
> >On Mon, Dec 14, 2015 at 10:08:16AM +0800, Qu Wenruo wrote:
> >>
> >>
> >>Martin Steigerwald wrote on 2015/12/13 23:35 +0100:
> >>>Hi!
> >>>
> >>>For me it is still not production ready.
> >>
> >>Yes, this is the *FACT* and not everyone has a good reason to deny it.
> >>
> >>>Again I ran into:
> >>>
> >>>btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random
> >>>write into big file
> >>>https://bugzilla.kernel.org/show_bug.cgi?id=90401
> >>
> >>Not sure about guideline for other fs, but it will attract more dev's
> >>attention if it can be posted to maillist.
> >>
> >>>
> >>>
> >>>No matter whether SLES 12 uses it as default for root, no matter whether
> >>>Fujitsu and Facebook use it: I will not let this onto any customer machine
> >>>without lots and lots of underprovisioning and rigorous free space monitoring.
> >>>Actually I will renew my recommendations in my trainings to be careful with
> >>>BTRFS.
> >>>
> >>> From my experience the monitoring would check for:
> >>>
> >>>merkaba:~> btrfs fi show /home
> >>>Label: 'home'  uuid: […]
> >>>         Total devices 2 FS bytes used 156.31GiB
> >>>         devid    1 size 170.00GiB used 164.13GiB path /dev/mapper/msata-home
> >>>         devid    2 size 170.00GiB used 164.13GiB path /dev/mapper/sata-home
> >>>
> >>>If "used" is same as "size" then make big fat alarm. It is not sufficient for
> >>>it to happen. It can run for quite some time just fine without any issues, but
> >>>I never have seen a kworker thread using 100% of one core for extended period
> >>>of time blocking everything else on the fs without this condition being met.
> >>>
> >>
> >>And specially advice on the device size from myself:
> >>Don't use devices over 100G but less than 500G.
> >>Over 100G will leads btrfs to use big chunks, where data chunks can be at
> >>most 10G and metadata to be 1G.
> >>
> >>I have seen a lot of users with about 100~200G device, and hit unbalanced
> >>chunk allocation (10G data chunk easily takes the last available space and
> >>makes later metadata no where to store)
> >
> >Maybe we should tune things so the size of the chunk is based on the
> >space remaining instead of the total space?
> 
> Submitted such patch before.
> David pointed out that such behavior will cause a lot of small fragmented
> chunks at last several GB.
> Which may make balance behavior not as predictable as before.
> 
> 
> At least, we can just change the current 10% chunk size limit to 5% to make
> such problem less easier to trigger.
> It's a simple and easy solution.
> 
> Another cause of the problem is, we understated the chunk size change for fs
> at the borderline of big chunk.
> 
> For 99G, its chunk size limit is 1G, and it needs 99 data chunks to fully
> cover the fs.
> But for 100G, it only needs 10 chunks to covert the fs.
> And it need to be 990G to match the number again.

max_stripe_size is fixed at 1GB and the chunk size is stripe_size * data_stripes,
may I know how your partition gets a 10GB chunk?


Thanks,

-liubo
 

> 
> The sudden drop of chunk number is the root cause.
> 
> So we'd better reconsider both the big chunk size limit and chunk size limit
> to find a balanaced solution for it.
> 
> Thanks,
> Qu
> >
> >>
> >>And unfortunately, your fs is already in the dangerous zone.
> >>(And you are using RAID1, which means it's the same as one 170G btrfs with
> >>SINGLE data/meta)
> >>
> >>>
> >>>In addition to that last time I tried it aborts scrub any of my BTRFS
> >>>filesstems. Reported in another thread here that got completely ignored so
> >>>far. I think I could go back to 4.2 kernel to make this work.
> >
> >We'll pick this thread up again, the ones that get fixed the fastest are
> >the ones that we can easily reproduce.  The rest need a lot of think
> >time.
> >
> >-chris
> >
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
