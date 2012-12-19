Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab2LSQP1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 11:15:27 -0500
Date: Wed, 19 Dec 2012 17:15:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Jan Steffens <jan.steffens@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG during log recovery
Message-ID: <20121219161525.GP14116@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAMQ-g0fNocHwEvbeDAf-HK+Nh4XcQDDD7Mi_ZxDSqv-moFKn5g@mail.gmail.com>
 <20121218134007.GB2403@localhost.localdomain>
 <CAMQ-g0cywb_kDoV4Dj4fbSYj3JujvbouUvuXPWJyffskcKafBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMQ-g0cywb_kDoV4Dj4fbSYj3JujvbouUvuXPWJyffskcKafBA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 03:10:24PM +0100, Jan Steffens wrote:
> 	if (!caching_ctl) {
> 		BUG_ON(!block_group_cache_done(block_group));
> 		ret = btrfs_remove_free_space(block_group, start, num_bytes);
> 		BUG_ON(ret); /* -ENOMEM */     // <<< 6185

The actual value of ret is = -11 = -EAGAIN (EAX: fffffff5 in the report)

> 	} else {
> 		mutex_lock(&caching_ctl->mutex);
> 
> 		if (start >= caching_ctl->progress) {
> 			ret = add_excluded_extent(root, start, num_bytes);
