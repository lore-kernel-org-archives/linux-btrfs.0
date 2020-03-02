Return-Path: <SRS0=j6ri=4T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2353C3F2CD
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Mar 2020 20:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70DDD214DB
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Mar 2020 20:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgCBUS2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 15:18:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:48998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCBUS2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Mar 2020 15:18:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CFCE4B264;
        Mon,  2 Mar 2020 20:18:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 19C9ADA7AA; Mon,  2 Mar 2020 21:18:05 +0100 (CET)
Date:   Mon, 2 Mar 2020 21:18:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH][RESEND] btrfs: kill update_block_group_flags
Message-ID: <20200302201804.GX2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20200117140826.42616-1-josef@toxicpanda.com>
 <2e16f37e-014e-6d86-76c6-801d6cb7bc20@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e16f37e-014e-6d86-76c6-801d6cb7bc20@applied-asynchrony.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Mar 01, 2020 at 06:58:02PM +0100, Holger Hoffstätte wrote:
> On 1/17/20 3:08 PM, Josef Bacik wrote:
> > +		alloc_flags = btrfs_get_alloc_profile(fs_info, cache->flags);
> >   		if (alloc_flags != cache->flags) {
> >   			ret = btrfs_chunk_alloc(trans, alloc_flags,
> >   						CHUNK_ALLOC_FORCE);
> > @@ -2252,7 +2204,7 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
> >   	ret = inc_block_group_ro(cache, 0);
> >   out:
> >   	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
> > -		alloc_flags = update_block_group_flags(fs_info, cache->flags);
> > +		alloc_flags = btrfs_get_alloc_profile(fs_info, cache->flags);
> >   		mutex_lock(&fs_info->chunk_mutex);
> >   		check_system_chunk(trans, alloc_flags);
> >   		mutex_unlock(&fs_info->chunk_mutex);
> > 
> 
> It seems that this patch breaks forced metadata rebalance from dup to single;
> all chunks remain dup (or are rewritten as dup again). I bisected the broken
> balance behaviour to this commit which for some reason was in my tree ;-) and
> reverting it immediately fixed things.
> 
> I don't (yet) see this applied anywhere, but couldn't find any discussion or
> revocation either. Maybe the logic between update_block_group_flags() and
> btrfs_get_alloc_profile() is not completely exchangeable?

The patch was not applied because I was not sure about it and had some
suspicion, https://lore.kernel.org/linux-btrfs/20200108170340.GK3929@twin.jikos.cz/
I don't want to apply the patch until I try the mentioned test with
raid1c34 but it's possible that it gets fixed by the updated patch.
