Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752469AbdDRLJL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 07:09:11 -0400
Date: Tue, 18 Apr 2017 13:09:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v6 2/2] btrfs: scrub: Fix RAID56 recovery race condition
Message-ID: <20170418110907.GR4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170414003555.4319-1-quwenruo@cn.fujitsu.com>
 <20170414003555.4319-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170414003555.4319-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 14, 2017 at 08:35:55AM +0800, Qu Wenruo wrote:
> When scrubbing a RAID5 which has recoverable data corruption (only one
> data stripe is corrupted), sometimes scrub will report more csum errors
> than expected. Sometimes even unrecoverable error will be reported.
> 
> The problem can be easily reproduced by the following steps:
> 1) Create a btrfs with RAID5 data profile with 3 devs
> 2) Mount it with nospace_cache or space_cache=v2
>    To avoid extra data space usage.
> 3) Create a 128K file and sync the fs, unmount it
>    Now the 128K file lies at the beginning of the data chunk
> 4) Locate the physical bytenr of data chunk on dev3
>    Dev3 is the 1st data stripe.
> 5) Corrupt the first 64K of the data chunk stripe on dev3
> 6) Mount the fs and scrub it
> 
> The correct csum error number should be 16(assuming using x86_64).
> Larger csum error number can be reported in a 1/3 chance.
> And unrecoverable error can also be reported in a 1/10 chance.
> 
> The root cause of the problem is RAID5/6 recover code has race
> condition, due to the fact that full scrub is initiated per device.
> 
> While for other mirror based profiles, each mirror is independent with
> each other, so race won't cause any big problem.
> 
> For example:
>         Corrupted       |       Correct          |      Correct        |
> |   Scrub dev3 (D1)     |    Scrub dev2 (D2)     |    Scrub dev1(P)    |
> ------------------------------------------------------------------------
> Read out D1             |Read out D2             |Read full stripe     |
> Check csum              |Check csum              |Check parity         |
> Csum mismatch           |Csum match, continue    |Parity mismatch      |
> handle_errored_block    |                        |handle_errored_block |
>  Read out full stripe   |                        | Read out full stripe|
>  D1 csum error(err++)   |                        | D1 csum error(err++)|
>  Recover D1             |                        | Recover D1          |
> 
> So D1's csum error is accounted twice, just because
> handle_errored_block() doesn't have enough protect, and race can happen.
> 
> On even worse case, for example D1's recovery code is re-writing
> D1/D2/P, and P's recovery code is just reading out full stripe, then we
> can cause unrecoverable error.
> 
> This patch will use previously introduced lock_full_stripe() and
> unlock_full_stripe() to protect the whole scrub_handle_errored_block()
> function for RAID56 recovery.
> So no extra csum error nor unrecoverable error.
> 
> Reported-by: Goffredo Baroncelli <kreijack@libero.it>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
