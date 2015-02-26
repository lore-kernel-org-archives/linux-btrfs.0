Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbbBZRqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 12:46:18 -0500
Date: Thu, 26 Feb 2015 18:46:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "'David Sterba'" <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        clm@fb.com
Subject: Re: [PULL] [PATCH 00/11] Cleanups for 4.1
Message-ID: <20150226174615.GA8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1424880058.git.dsterba@suse.cz>
 <009a01d05165$2112c790$633856b0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <009a01d05165$2112c790$633856b0$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 26, 2015 at 09:39:57AM +0800, Zhao Lei wrote:
> I like these cleanups.
> 
> But it cause following build warnings:
>   fs/btrfs/volumes.c: In function ‘__btrfs_map_block’:
>   fs/btrfs/volumes.c:5206: warning: unused variable ‘tmp’
> 
>   fs/btrfs/free-space-cache.c: In function ‘recalculate_thresholds’:
>   fs/btrfs/free-space-cache.c:1527: warning: comparison of distinct pointer types lacks a cast
> 
> And little checkpatch notice:
>   ERROR: "foo* bar" should be "foo *bar"
>   #41: FILE: fs/btrfs/sysfs.h:70:
>   +static inline struct kobj_attribute* attr_to_btrfs_attr(struct attribute *attr)
> In [PATCH 09/11].
> 
> Could you fix it?

Will do.
