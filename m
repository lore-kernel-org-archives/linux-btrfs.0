Return-Path: <SRS0=0Ua4=ZK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27C7C432C3
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 18:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5E792063A
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 18:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfKRSXi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 13:23:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:59316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbfKRSXi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Nov 2019 13:23:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3FB9AD7F;
        Mon, 18 Nov 2019 18:10:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 44DCEDA823; Mon, 18 Nov 2019 19:10:04 +0100 (CET)
Date:   Mon, 18 Nov 2019 19:10:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 0/4] btrfs-progs: Compiling warning fixes for devel branch
Message-ID: <20191118181003.GL3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, osandov@osandov.com
References: <20191118063052.56970-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118063052.56970-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 18, 2019 at 02:30:48PM +0800, Qu Wenruo wrote:
> We have several compiling errors, in devel branch.
> One looks like a false alert from compiler, the first patch will
> workaround it.
> 
> 3 warning from libbtrfsutils are due to python3.8 changes.
> Handle it properly by using designated initialization, which also saves
> us quite some lines.
> 
> Qu Wenruo (4):
>   btrfs-progs: check/lowmem: Fix a false alert on uninitialized value
>   btrfs-progs: libbtrfsutil: Convert to designated initialization for
>     BtrfsUtilError_type
>   btrfs-progs: libbtrfsutil: Convert to designated initialization for
>     QgroupInherit_type
>   btrfs-progs: libbtrfsutil: Convert to designated initialization for
>     SubvolumeIterator_type

Added to devel, thanks. Please note that libbtrfsutil does not need the
btrfs-progs prefix, as it's considered a separate part.
