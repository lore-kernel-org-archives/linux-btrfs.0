From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] btrfs: fix write_dev_supers
Date: Tue, 09 Jun 2009 20:28:23 +0900
Message-ID: <6.0.0.20.2.20090609202623.072644a8@172.19.0.2>
References: <6.0.0.20.2.20090608181508.05e4b708@172.19.0.2>
 <20090609112516.GB4009@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090609112516.GB4009@think>
List-ID: <linux-btrfs.vger.kernel.org>


At 20:25 09/06/09, Chris Mason wrote:
>On Tue, Jun 09, 2009 at 10:46:55AM +0900, Hisashi Hifumi wrote:
>> Hi.
>> 
>> I got following BUG trace.
>> This is violation of BUG_ON(!buffer_locked(bh)) check on submit_bh() function.
>> In write_dev_supers(), if wait parameter is set and buffer_uptodate() check
>> is negative,  submit_bh() is executed and hit above BUG_ON.
>> So I fixed this issue.
>
>Thanks for finding this bug and sending the patch.
>
>This function is very confusing.  If wait parameter is set, it
>isn't supposed to do any IO at all.  The caller first does
>write_dev_supers with wait == 0, and that sends all the supers down on
>all the devices.
>
>Then it calls again with wait == 1, which is supposed to make sure all
>the supers actually got to disk.
>
>We should change the wait == 0 behavior to leave a reference held on all
>the buffers, and wait == 1 to drop that reference.  That way the buffer
>won't disappear while we are waiting, and we can return an error if the
>buffer wasn't up to date when wait == 1.
>
>Are you interested in fixing this?

Yes, I want to fix this. 

