Return-Path: <SRS0=y2QO=76=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DB1C433E1
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 11:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0CB207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 11:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgFQLiK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 07:38:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:49454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbgFQLiJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jun 2020 07:38:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9E1B9AE0B;
        Wed, 17 Jun 2020 11:38:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 36481DA7C3; Wed, 17 Jun 2020 13:37:59 +0200 (CEST)
Date:   Wed, 17 Jun 2020 13:37:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/46] Trivial BTRFS_I removal
Message-ID: <20200617113759.GL27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200603055546.3889-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603055546.3889-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 03, 2020 at 08:55:00AM +0300, Nikolay Borisov wrote:
> V2 with purely cosmetic changes in the line length of some patches' changelogs.
> 
> For the cover letter of substance for this series check v1 [0] cover letter.
> 
> [0] https://lore.kernel.org/linux-btrfs/SN4PR0401MB3598824C8AE02453F8ABD61A9B8B0@SN4PR0401MB3598.namprd04.prod.outlook.com/T/#t
> 
> Nikolay Borisov (46):
>   btrfs: Make __btrfs_add_ordered_extent take struct btrfs_inode
>   btrfs: Make get_extent_allocation_hint take btrfs_inode
>   btrfs: Make btrfs_lookup_ordered_extent take btrfs_inode
>   btrfs: Make btrfs_reloc_clone_csums take btrfs_inode
>   btrfs: Make create_io_em take btrfs_inode
>   btrfs: Make extent_clear_unlock_delalloc take btrfs_inode
>   btrfs: Make btrfs_csum_one_bio takae btrfs_inode
>   btrfs: Make __btrfs_drop_extents take btrfs_inode

I've applied 1-8 to misc-next, that's what applied cleanly when I first
looked at the series and still applies now, with a minor conflict and
manual fix to recently added "btrfs: fix RWF_NOWAIT writes blocking on
extent locks and waiting for IO".

46 in one go seem to be too much, I'll try to apply the rest in case the
fixups won't get out of hand.
