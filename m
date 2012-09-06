Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41263 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2IFOMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2012 10:12:24 -0400
Message-ID: <5048AF3C.6020305@gmail.com>
Date: Thu, 06 Sep 2012 22:12:12 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: remove unnecessary -ENOMEM BUG_ON check in
 extent-tree.c/exclude_super_stripes
References: <50484569.8080709@gmail.com> <20120906100923.GO17430@twin.jikos.cz>
In-Reply-To: <20120906100923.GO17430@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012年09月06日 18:09, David Sterba wrote:
> On Thu, Sep 06, 2012 at 02:40:41PM +0800, Wang Sheng-Hui wrote:
>> The memory allocation failure is BUG_ON in add_excluded_extent (following
>> the code path) and btrfs_rmap_block. No need to BUG_ON -ENOMEM inside
>> exclude_super_stripes itself.
> 
> No please.
> 
>> Its return value is always 0, and useless for its callers. Set it as void
>> instead 0-returned.
> 
> btrfs_rmap_block itself contains a BUG_ON:
> 
> 3980 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
> 3981                      u64 chunk_start, u64 physical, u64 devid,
> 3982                      u64 **logical, int *naddrs, int *stripe_len)
> 3983 {
> 3984         struct extent_map_tree *em_tree = &map_tree->map_tree;
> 3985         struct extent_map *em;
> 3986         struct map_lookup *map;
> 3987         u64 *buf;
> 3988         u64 bytenr;
> 3989         u64 length;
> 3990         u64 stripe_nr;
> 3991         int i, j, nr = 0;
> 3992
> 3993         read_lock(&em_tree->lock);
> 3994         em = lookup_extent_mapping(em_tree, chunk_start, 1);
> 3995         read_unlock(&em_tree->lock);
> 3996
> 3997         BUG_ON(!em || em->start != chunk_start);
> 
> And this should be turned into an 'return error', thus giving a non-zero return
> code that should be handled in the callers.
> 
> Eg. this patch attempts to do that
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg15470.html
> 
> but has not been merged due to incorrect fix inside exclude_super_stripes
> (introduced in the patch).
> 
> The same objection for return code cleanups will hold for any function that
> returns 0 but is full of BUG_ONs.
> 
> 
> david

Got it. Thanks, David!

Regards,
Sheng-Hui
