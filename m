Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:55416 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbbJIEvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Oct 2015 00:51:04 -0400
From: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
To: Josef Bacik <jbacik@fb.com>
CC: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix waitqueue_active without memory barrier in
 btrfs
Date: Fri, 9 Oct 2015 04:50:35 +0000
Message-ID: <17EC94B0A072C34B8DCF0D30AD16044A028749C1@BPXM09GP.gisp.nec.co.jp>
In-Reply-To: <56174371.8080107@fb.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On 10/08/2015 05:35 PM, Kosuke Tatsukawa wrote:
>> btrfs_bio_counter_sub() seems to be missing a memory barrier which might
>> cause the waker to not notice the waiter and miss sending a wake_up as
>> in the following figure.
>> 
>> 	btrfs_bio_counter_sub			btrfs_rm_dev_replace_blocked
>> ------------------------------------------------------------------------
>> if (waitqueue_active(&fs_info->replace_wait))
>> /* The CPU might reorder the test for
>>     the waitqueue up here, before
>>     prior writes complete */
>> 					/* wait_event */
>> 					 /* __wait_event */
>> 					  /* ___wait_event */
>> 					  long __int = prepare_to_wait_event(&wq,
>> 					    &__wait, state);
>> 					  if (!percpu_counter_sum(&fs_info->bio_counter))
>> percpu_counter_sub(&fs_info->bio_counter,
>>    amount);
>> 					  schedule()
>
> percpu_counter_sub can't be reordered, in its most basic form it does
> preempt_disable/enable which in its most basic form does barrier().  Thanks,

It's not the compiler, but the CPU that is doing the reordering.

The CPU can delay the write of the counter, so that the following read
of &fs_info->replace_wait is completed first.  Hence a memory barrier is
required, and not just a barrier.
---
Kosuke TATSUKAWA  | 3rd IT Platform Department
                  | IT Platform Division, NEC Corporation
                  | tatsu@ab.jp.nec.com
