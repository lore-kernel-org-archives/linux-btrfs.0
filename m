Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbeHWTa2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 15:30:28 -0400
Date: Thu, 23 Aug 2018 17:59:55 +0200
From: David Sterba <dsterba@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, WenRuo Qu <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: fs/btrfs/volumes.c:6114 suspicious rcu_dereference_check() usage!
Message-ID: <20180823155955.GO24025@suse.cz>
Reply-To: dsterba@suse.cz
References: <22614.1535039351@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22614.1535039351@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2018 at 04:49:11PM +0100, David Howells wrote:
> I'm seeing the attached message generated from this line:
> 
> 	btrfs_debug_in_rcu(fs_info,
> 	"btrfs_map_bio: rw %d 0x%x, sector=%llu, dev=%lu (%s id %llu), size=%u",
> 		bio_op(bio), bio->bi_opf, (u64)bio->bi_iter.bi_sector,
> 		(u_long)dev->bdev->bd_dev, rcu_str_deref(dev->name), dev->devid,
> 		bio->bi_iter.bi_size);
> 
> in submit_stripe_bio().  I'm not sure exactly why, but I suspect
> rcu_str_deref() is the point from where it is generated.

Yes, the macro is rcu_dereference in disguise.

The code previously had explicit rcu_lock/unlock, now it uses the
btrfs_debug_in_rcu helper which is supposed to provide that. It's
possible that the helper is missing it due to some #ifdef mess, but I
don't see it.
