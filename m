Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3HASfH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 14:35:07 -0400
Date: Thu, 1 Aug 2013 11:35:05 -0700
From: Zach Brown <zab@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v5 5/5] Btrfs: online data deduplication
Message-ID: <20130801183505.GD12314@lenny.home.zabbo.net>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
 <1375285066-14173-6-git-send-email-bo.li.liu@oracle.com>
 <20130731225050.GN32145@lenny.home.zabbo.net>
 <20130801101457.GB20228@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130801101457.GB20228@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> So do you mean that our whole hash value will be (key.objectid + bytes)
> because key.objectid is a part of hash value?

I think so, if I understood your question.  The idea is to not store the
bytes of the hash that make up the objectid more than once so the tree
items are smaller.

For example:

+	read_extent_buffer(leaf, hash_in_item, ((unsigned long)hash_item),
+			   BTRFS_DEDUP_HASH_SIZE);

That'd be (_SIZE - sizeof(u64)) if the bytes of the hash that made up
the object id weren't also stored in the item payload.

- z
