Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47660 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933399AbdCHBOv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 20:14:51 -0500
Date: Tue, 7 Mar 2017 17:12:58 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Xin Zhou <xin.zhou@gmx.com>, Roman Mamedov <rm@romanrm.net>,
        Filipe Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix hole read corruption for compressed inline
 extents
Message-ID: <20170308011258.GI12408@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1480309392-4786-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <20161128172710.202587ce@natsu>
 <20161211051641.GA21290@hungrycats.org>
 <trinity-05c92524-3d70-42a6-b8cd-f9bf40f58f9a-1481493419884@3capp-mailcom-bs05>
 <20161213064012.GX8685@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20161213064012.GX8685@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Zygo,

On Tue, Dec 13, 2016 at 01:40:13AM -0500, Zygo Blaxell wrote:
> On Sun, Dec 11, 2016 at 10:56:59PM +0100, Xin Zhou wrote:
> >    Hi Zygo,
> >     
> >    Since the corruption happens after I/O and checksum,
> >    could it be possible to add some bug catcher code in debug build, to help
> >    narrowing down the issue?
> 
> The corruption happens only during reads, after IO and checksum.
> It happens at the point that I have patched, after decompression when
> the decompressed data doesn't fill the extent and there is a hole after
> the extent.  No other code exists in btrfs to fill the hole that forms
> in such cases.  There is nothing left to narrow down.
> 
> Chris Mason discovered the same bug in 2009 and fixed half of it in commit
> 93c82d5750.  His fix only fixed one of two cases where corruption occurs
> (i.e. after uncompressed extents).  The compressed extent case remained
> unfixed until the present.
> 
> To be fair to everyone who missed this bug for seven years:  it was
> quite a hard bug to spot.  Over a period of 28 months I observed backup
> verification failures and eliminated competing theories until only this
> bug remained.
> 
> There were at least two other bugs fixed between 2009 and 2014 which
> would have also produced corrupted data in compressed files under
> slightly different circumstances, so anyone looking for data corruption
> in compressed extents would have thought they'd solved the problem at
> least twice before now.
> 
> There was a memset in *almost* the right spot in the code to fix the
> corruption bug until early 2014.  Ironically, that memset (which was
> introduced in 2009) was itself the cause of another corruption bug.
> The memset was removed in 166ae5a418 ("btrfs: fix inline compressed read
> err corruption") but that commit removed the memset entirely instead of
> fixing it.
>

Thanks for the nice analysis here, so I think btrfs does have this
problem, I could reproduce this with fallocate if using
'page_poison=on' kernel command line (or enable CONFIG_PAGE_POISONING).

Here are the steps,

# touch foo
# chattr +c foo
# xfs_io -f -c "pwrite -W 0 1000" foo
# xfs_io -f -c "falloc 4 8188" foo
# od -x foo
# echo 3 >/proc/sys/vm/drop_caches
# od -x foo

This produce the following on my box:

0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0001740 cdcd cdcd cdcd cdcd 0000 0000 0000 0000
0001760 0000 0000 0000 0000 0000 0000 0000 0000
*
0020000



0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0001740 cdcd cdcd cdcd cdcd 6c63 7400 635f 006d
0001760 5f74 6f43 7400 435f 0053 5f74 7363 7400
0002000 435f 0056 5f74 6164 7400 645f 0062 5f74
(...)



Regarding to this patch,

- Although pg_offset is assumed to be zero, using (PAGE_SIZE -
  pg_offset) makes the code look saner, could you please add pg_offset
  to the check?

- Could you please wrap my reproducer script into the commit log so
  that a later test could catch the point quickly?

With those added, you can add

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
