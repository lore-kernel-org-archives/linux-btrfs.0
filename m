Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10600 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbbJIEdC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Oct 2015 00:33:02 -0400
Subject: Re: [PATCH] btrfs: fix waitqueue_active without memory barrier in
 btrfs
To: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>
References: <17EC94B0A072C34B8DCF0D30AD16044A02874794@BPXM09GP.gisp.nec.co.jp>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <56174371.8080107@fb.com>
Date: Thu, 8 Oct 2015 21:32:49 -0700
MIME-Version: 1.0
In-Reply-To: <17EC94B0A072C34B8DCF0D30AD16044A02874794@BPXM09GP.gisp.nec.co.jp>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/08/2015 05:35 PM, Kosuke Tatsukawa wrote:
> btrfs_bio_counter_sub() seems to be missing a memory barrier which might
> cause the waker to not notice the waiter and miss sending a wake_up as
> in the following figure.
> 
> 	btrfs_bio_counter_sub			btrfs_rm_dev_replace_blocked
> ------------------------------------------------------------------------
> if (waitqueue_active(&fs_info->replace_wait))
> /* The CPU might reorder the test for
>     the waitqueue up here, before
>     prior writes complete */
> 					/* wait_event */
> 					 /* __wait_event */
> 					  /* ___wait_event */
> 					  long __int = prepare_to_wait_event(&wq,
> 					    &__wait, state);
> 					  if (!percpu_counter_sum(&fs_info->bio_counter))
> percpu_counter_sub(&fs_info->bio_counter,
>    amount);
> 					  schedule()

percpu_counter_sub can't be reordered, in its most basic form it does
preempt_disable/enable which in its most basic form does barrier().  Thanks,

Josef
