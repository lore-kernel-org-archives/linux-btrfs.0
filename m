Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab3AJRKn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 12:10:43 -0500
Date: Thu, 10 Jan 2013 18:10:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 05/11] Btrfs: protect fs_info->alloc_start
Message-ID: <20130110171040.GG20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50EEB880.4060308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50EEB880.4060308@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 08:48:00PM +0800, Miao Xie wrote:
> fs_info->alloc_start was not protected strictly, it might be changed while
> we were accessing it. This patch fixes this problem by using two locks to
> protect it (fs_info->chunk_mutex and sb->s_umount). On the read side, we
> just need get one of these two locks, and on the write side, we must lock
> all of them.

Can you please describe how this can theoretically cause any problems?

Out of curiosity I've been running this command on a 60G ssd disk for a while

for i in `seq 1 10000|shuf`;do
	mount -o remount,alloc_start=$(($i*1024*1024)) /mnt/sdc;done
	#sleep 0 / 1 / 5
done

together with one of my favourite stresstests (heavy writes, subvolume
activity).

There are two direct users of fs_info->alloc_start:

* statfs via btrfs_calc_avail_data_space
* find_free_dev_extent

960         search_start = max(root->fs_info->alloc_start, 1024ull * 1024);

as remount calls sync, there is a very tiny window where an allocation could
get the old value of alloc_start just between sync and do_remount. Theoretical
and without any visible effect.

My NAK for this patch.

david
