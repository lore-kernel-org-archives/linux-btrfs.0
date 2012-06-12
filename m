Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2FLNnV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 09:43:21 -0400
Date: Tue, 12 Jun 2012 09:43:19 -0400
From: Josef Bacik <josef@redhat.com>
To: Zach Brown <zab@zabbo.net>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        wfg@linux.intel.com
Subject: Re: [PATCH] Btrfs: use rcu to protect device->name V2
Message-ID: <20120612134318.GD1565@localhost.localdomain>
References: <1339421426-1921-1-git-send-email-josef@redhat.com>
 <4FD65ECA.1030502@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD65ECA.1030502@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 11, 2012 at 02:10:34PM -0700, Zach Brown wrote:
> 
> >-		if (state->print_mask&  BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
> >+		if (state->print_mask&  BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE) {
> >+			struct rcu_string *name;
> >+
> >+			rcu_read_lock();
> >+			name = rcu_dereference(device->name);
> >  			printk(KERN_INFO "New initial S-block (bdev %p, %s)"
> >  			       " @%llu (%s/%llu/%d)\n",
> >-			       superblock_bdev, device->name,
> >+			       superblock_bdev, name->str,
> >  			       (unsigned long long)dev_bytenr,
> >  			       dev_state->name,
> >  			       (unsigned long long)dev_bytenr,
> >  			       superblock_mirror_num);
> >+			rcu_read_unlock();
> >+		}
> 
> That's a whole lot of noise at every call site.  How about some helpers?
> In sloppy-code..
> 
> #define printk_in_rcu(args) do { rcu; printk; rcu; } while (0)
> 
> #define device_name_rcu(dev) ({
> 	struct rcu_string *name = rcu_dereference(dev->name);
> 	name->str; )}
> 
> 	printk_in_rcu("HELLO FRIENDS %s", device_name_rcu(dev));
> 
> It's kind of annoying to have a wrapper for printk(), pr_debug(), etc,
> but it sure seems better than implementing the rcu consistency rules
> around every output.  (And multiple rcu_string locals for multiple
> device names..)
> 

Oh and now I remember why I didn't do this (other than being terribly lazy), all
the call sites are too different, and there's no simple way to figure out which
arg is the device name so I can do the derefence properly.  We'd need to change
all of the messages to have a unified format so that it could just be something
like

#define device_name_printk(dev, level, fmt, ...) do {		\
	struct rcu_string *name;				\
								\
	rcu_read_lock();					\
	name = rcu_dereference(dev->name);			\
	printk(level "%s: " fmt, name->str, ##__VA_ARGS__);	\
	rcu_read_unlock();					\
	} while (0)

and I'm not even sure if that would work out right with the args.  Do we really
want to force everybody to this one convention?  If the answer is yes then
damnit I don't wanna because it's tedious ;).  Thanks,

Josef
