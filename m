Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbbJIOW3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Oct 2015 10:22:29 -0400
Date: Fri, 9 Oct 2015 16:21:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix waitqueue_active without memory barrier in
 btrfs
Message-ID: <20151009142119.GC27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <17EC94B0A072C34B8DCF0D30AD16044A02874794@BPXM09GP.gisp.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <17EC94B0A072C34B8DCF0D30AD16044A02874794@BPXM09GP.gisp.nec.co.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 09, 2015 at 12:35:48AM +0000, Kosuke Tatsukawa wrote:
> This patch removes the call to waitqueue_active() leaving just wake_up()
> behind.  This fixes the problem because the call to spin_lock_irqsave()
> in wake_up() will be an ACQUIRE operation.

Either we can switch it to wake_up or put the barrier before the check.
Not all instances of waitqueue_active need the barrier though.

> I found this issue when I was looking through the linux source code
> for places calling waitqueue_active() before wake_up*(), but without
> preceding memory barriers, after sending a patch to fix a similar
> issue in drivers/tty/n_tty.c  (Details about the original issue can be
> found here: https://lkml.org/lkml/2015/9/28/849).

There are more in btrfs:

https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg41914.html

> @@ -918,9 +918,7 @@ void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
>  void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
>  {
>  	percpu_counter_sub(&fs_info->bio_counter, amount);
> -
> -	if (waitqueue_active(&fs_info->replace_wait))
> -		wake_up(&fs_info->replace_wait);
> +	wake_up(&fs_info->replace_wait);

Chris had a comment on that one in
https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg42551.html
it's in performance critial context and the explicit wake_up is even
worse than the barrier.
