Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:37173 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbJJFEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 01:04:11 -0400
From: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix waitqueue_active without memory barrier in
 btrfs
Date: Sat, 10 Oct 2015 05:03:29 +0000
Message-ID: <17EC94B0A072C34B8DCF0D30AD16044A02875F9F@BPXM09GP.gisp.nec.co.jp>
In-Reply-To: <20151009142119.GC27761@twin.jikos.cz>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> On Fri, Oct 09, 2015 at 12:35:48AM +0000, Kosuke Tatsukawa wrote:
>> This patch removes the call to waitqueue_active() leaving just wake_up()
>> behind.  This fixes the problem because the call to spin_lock_irqsave()
>> in wake_up() will be an ACQUIRE operation.
>
> Either we can switch it to wake_up or put the barrier before the check.
> Not all instances of waitqueue_active need the barrier though.
>
>> I found this issue when I was looking through the linux source code
>> for places calling waitqueue_active() before wake_up*(), but without
>> preceding memory barriers, after sending a patch to fix a similar
>> issue in drivers/tty/n_tty.c  (Details about the original issue can be
>> found here: https://lkml.org/lkml/2015/9/28/849).
>
> There are more in btrfs:
>
> https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg41914.html

Thank you for the pointer.
Your patch seems better than mine.

I think the other places in btrfs that use waitqueue_active() before
wake_up are preceded by either a smp_mb or some kind of atomic
operation.

The latter still needs smp_mb__after_atomic() but it's light-weight
compared to smp_mb().


>> @@ -918,9 +918,7 @@ void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
>>  void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
>>  {
>>  	percpu_counter_sub(&fs_info->bio_counter, amount);
>> -
>> -	if (waitqueue_active(&fs_info->replace_wait))
>> -		wake_up(&fs_info->replace_wait);
>> +	wake_up(&fs_info->replace_wait);
>
> Chris had a comment on that one in
> https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg42551.html
> it's in performance critial context and the explicit wake_up is even
> worse than the barrier.
---
Kosuke TATSUKAWA  | 3rd IT Platform Department
                  | IT Platform Division, NEC Corporation
                  | tatsu@ab.jp.nec.com
