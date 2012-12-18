Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41801 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab2LROcs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 09:32:48 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb11so576866pad.24
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 06:32:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121218134007.GB2403@localhost.localdomain>
References: <CAMQ-g0fNocHwEvbeDAf-HK+Nh4XcQDDD7Mi_ZxDSqv-moFKn5g@mail.gmail.com>
	<20121218134007.GB2403@localhost.localdomain>
Date: Tue, 18 Dec 2012 15:10:24 +0100
Message-ID: <CAMQ-g0cywb_kDoV4Dj4fbSYj3JujvbouUvuXPWJyffskcKafBA@mail.gmail.com>
Subject: Re: BUG during log recovery
From: Jan Steffens <jan.steffens@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 2:40 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Fri, Dec 14, 2012 at 03:04:08PM -0700, Jan Steffens wrote:
>> After a lockup requiring a hard reset, the btrfs could not be mounted,
>> throwing the following error:
>>
>
> Could you tell me what line this comes out to?  Give me a few lines of context
> so I can figure out where it's happening.  Thanks,
>
> Josef

Sure, here:

	caching_ctl = get_caching_control(block_group);

	if (!caching_ctl) {
		BUG_ON(!block_group_cache_done(block_group));
		ret = btrfs_remove_free_space(block_group, start, num_bytes);
		BUG_ON(ret); /* -ENOMEM */     // <<< 6185
	} else {
		mutex_lock(&caching_ctl->mutex);

		if (start >= caching_ctl->progress) {
			ret = add_excluded_extent(root, start, num_bytes);
