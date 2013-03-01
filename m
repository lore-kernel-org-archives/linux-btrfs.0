Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3CASTL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 13:19:11 -0500
Date: Fri, 1 Mar 2013 10:18:27 -0800
From: Zach Brown <zab@redhat.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: try harder to allocate raid56 stripe cache
Message-ID: <20130301181827.GV1658@lenny.home.zabbo.net>
References: <1362150180-13792-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362150180-13792-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The stripe hash table is large, starting with allocation order 4 and can go as
> high as order 7 in case lock debugging is turned on and structure padding
> happens.

Agreed, this should be fixed.

> -	table = kzalloc(sizeof(*table) + sizeof(*h) * num_entries, GFP_NOFS);

> +	table = kzalloc(table_size, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);

I guess this lost _NOFS on purpose because it was always being done in
mount?  But if it's done on-demand as Chris wanted it might be called
from paths that'd need _NOFS again?

- z
