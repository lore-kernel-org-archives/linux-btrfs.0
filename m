Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755797AbdJJLdG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 07:33:06 -0400
Date: Tue, 10 Oct 2017 13:31:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com
Subject: Re: [PATCH] btrfs: fix max chunk size on dup
Message-ID: <20171010113119.GJ3521@suse.cz>
Reply-To: dsterba@suse.cz
References: <150666965116.9802.15216393306253897797.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <150666965116.9802.15216393306253897797.stgit@naota.dhcp.fujisawa.hgst.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Sep 29, 2017 at 04:20:51PM +0900, Naohiro Aota wrote:
> Balancing a fresh METADATA=dup btrfs file system (with size < 50G)
> generates a 128MB sized block group. While we set max_stripe_size =
> max_chunk_size = 256MB, we get this half sized block group:
> 
> $ btrfs ins dump-t -t CHUNK_TREE btrfs.img|grep length
>                 length 8388608 owner 2 stripe_len 65536 type DATA
>                 length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
>                 length 134217728 owner 2 stripe_len 65536 type METADATA|DUP
> 
> Before commit 86db25785a6e ("Btrfs: fix max chunk size on raid5/6"), we
> used "stripe_size * ndevs > max_chunk_size * ncopies" to check the max
> chunk size. Since stripe_size = 256MB * dev_stripes (= 2) = 512MB, ndevs
> = 1, max_chunk_size = 256MB, and ncopies = 2, we allowed 256MB
> METADATA|DUP block group.
> 
> But now, we use "stripe_size * data_stripes > max_chunk_size". Since
> data_stripes = 1 on DUP, it disallows the block group to have > 128MB.
> What missing here is "dev_stripes". Proper logical space used by the block
> group is "stripe_size * data_stripes / dev_stripes". Tweak the equations to
> use the right value.

I started looking into it and still don't fully understand it. Change
deep in the allocator can easily break some blockgroup combinations, so
I'm rather conservative here.
