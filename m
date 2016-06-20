Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38282 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbcFTLdQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 07:33:16 -0400
Received: by mail-wm0-f52.google.com with SMTP id r201so57383339wme.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 04:33:00 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
From: Nikolay Borisov <kernel@kyup.com>
Subject: On shrinkable caches
Message-ID: <5767D2D4.4090709@kyup.com>
Date: Mon, 20 Jun 2016 14:26:12 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a question regarding the SLAB_RECLAIM_ACCOUNT flag with which
BTRFS caches are created. Currently there isn't a single usage of
register_shrinker under fs/btrfs. Apart from the inode cache which is
being shrunk from the generic super_cache_scan I don't think the memory
used for those caches should be accounted as reclaimable?

Regards,
Nikolay
