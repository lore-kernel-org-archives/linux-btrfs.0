Return-Path: <SRS0=hn/e=EJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C599AC2D0A3
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Nov 2020 09:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B6C223BD
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Nov 2020 09:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgKCJdF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 04:33:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:42620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgKCJdF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Nov 2020 04:33:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E96FFADC5;
        Tue,  3 Nov 2020 09:33:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 66056DA7D2; Tue,  3 Nov 2020 10:31:26 +0100 (CET)
Date:   Tue, 3 Nov 2020 10:31:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] btrfs: use precalculated sectorsize_bits from
 fs_info
Message-ID: <20201103093126.GK6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1603981452.git.dsterba@suse.com>
 <b38721840b8d703a29807b71460464134b9ca7e1.1603981453.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b38721840b8d703a29807b71460464134b9ca7e1.1603981453.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I got some comments,

On Thu, Oct 29, 2020 at 03:27:37PM +0100, David Sterba wrote:
> -	return ncsums * fs_info->sectorsize;
> +	return ncsums << fs_info->sectorsize_bits;

I'll restore all multiplications back, the shifts make it slightly worse
to read

> @@ -465,7 +465,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>  			start = key.offset;
>  
>  		size = btrfs_item_size_nr(leaf, path->slots[0]);
> -		csum_end = key.offset + (size / csum_size) * fs_info->sectorsize;
> +		csum_end = key.offset +
> +			   ((size / csum_size) >> fs_info->sectorsize_bits);

And this was buggy as I've been told, shift wrong way
