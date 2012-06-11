Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lulu.zabbo.net ([69.168.54.52]:54993 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2FKVTR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 17:19:17 -0400
Message-ID: <4FD65ECA.1030502@zabbo.net>
Date: Mon, 11 Jun 2012 14:10:34 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org, wfg@linux.intel.com
Subject: Re: [PATCH] Btrfs: use rcu to protect device->name V2
References: <1339421426-1921-1-git-send-email-josef@redhat.com>
In-Reply-To: <1339421426-1921-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -		if (state->print_mask&  BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
> +		if (state->print_mask&  BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE) {
> +			struct rcu_string *name;
> +
> +			rcu_read_lock();
> +			name = rcu_dereference(device->name);
>   			printk(KERN_INFO "New initial S-block (bdev %p, %s)"
>   			       " @%llu (%s/%llu/%d)\n",
> -			       superblock_bdev, device->name,
> +			       superblock_bdev, name->str,
>   			       (unsigned long long)dev_bytenr,
>   			       dev_state->name,
>   			       (unsigned long long)dev_bytenr,
>   			       superblock_mirror_num);
> +			rcu_read_unlock();
> +		}

That's a whole lot of noise at every call site.  How about some helpers?
In sloppy-code..

#define printk_in_rcu(args) do { rcu; printk; rcu; } while (0)

#define device_name_rcu(dev) ({
	struct rcu_string *name = rcu_dereference(dev->name);
	name->str; )}

	printk_in_rcu("HELLO FRIENDS %s", device_name_rcu(dev));

It's kind of annoying to have a wrapper for printk(), pr_debug(), etc,
but it sure seems better than implementing the rcu consistency rules
around every output.  (And multiple rcu_string locals for multiple
device names..)

- z
