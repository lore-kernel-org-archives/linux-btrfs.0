Return-Path: <SRS0=vkwB=B5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383B2C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 14:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19CE62078D
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Aug 2020 14:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597846897;
	bh=jpRfui17lA3nFG0e1CxOk2FPwyfMV1V22Ev0GKkWB5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SzzGN4t/pPyV5i5+NQd1exQ/UNXqFU1ihE63W/ENgM2gCIt9FtzWgJ27ub0gqn6fS
	 ou7NWptKNbs2HQCl1/hFNznLJSD4OII1zgZH5g8A68kf34GUW89RG+TjDqTiW99O4/
	 pNLNbnV1jZwxuThuV8rvgsuROOAddp4aDoSyP370=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgHSOVd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 10:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgHSOVd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Aug 2020 10:21:33 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D7D20639;
        Wed, 19 Aug 2020 14:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597846892;
        bh=jpRfui17lA3nFG0e1CxOk2FPwyfMV1V22Ev0GKkWB5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X7zfblykkgvANcP9POyOnUxHDXg9cDz4FFVBE/kIQ3PAKcFHmFmfQn0VQaZiMxBbE
         /MPHy0sqMsKnVuvCGfgtlRiSkpegn72o6mWRIeAjl7RV7341ZeaysZkrefaDaLln6w
         H8zIbQGGMZe81k9Et5xXtpWLWxewHx8qV6THQgtg=
Date:   Wed, 19 Aug 2020 17:21:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fixes to GCC warnings while compiling with W=1 level
Message-ID: <20200819142129.GW7555@unreal>
References: <20200819141630.1338693-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819141630.1338693-1-leon@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 19, 2020 at 05:16:27PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Hi,
>
> The series of trivial fixes for GCC warnings seen while compiling with W=1.
>
> Thanks
>
> Leon Romanovsky (3):
>   fs/btfrs: Fix -Wunused-but-set-variable warnings
      ^^^ this is typo - btrfs

>   fs/btrfs: Fix -Wignored-qualifiers warnings
>   fs/btrfs: Fix -Wmissing-prototypes warnings
>
>  fs/btrfs/compression.c | 35 -----------------------------------
>  fs/btrfs/compression.h | 35 +++++++++++++++++++++++++++++++++++
>  fs/btrfs/ctree.c       |  2 +-
>  fs/btrfs/ctree.h       |  2 +-
>  fs/btrfs/sysfs.c       |  7 +++----
>  fs/btrfs/sysfs.h       |  2 +-
>  6 files changed, 41 insertions(+), 42 deletions(-)
>
> --
> 2.26.2
>
