Return-Path: <SRS0=o3AA=5B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71513C18E5B
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Mar 2020 08:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A1F620719
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Mar 2020 08:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584346829;
	bh=Gb7YWQB1S6bVtJpIVGMzCmbQhj/wRcSCtzuilMMDbCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uhLk8pX33rXwsVjb64C0tgR+lNkAUikrSC5l3DwejFosTTuYs3LWhPtqo3SAlscnS
	 ZD37HlFwmf8Gk16yJmeiM+QDnn3z4fo+tdwz0qbMaTe8bjNLpixaH6ETKdYg6dTQGi
	 IXHZJqvwQ2BeAL7flFxE6zZD7YZa0qs4QaQH7v9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgCPIU0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729994AbgCPIU0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Mar 2020 04:20:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48ADA20674;
        Mon, 16 Mar 2020 08:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584346823;
        bh=Gb7YWQB1S6bVtJpIVGMzCmbQhj/wRcSCtzuilMMDbCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yLKNJWnQsuUzhoIulmw596ppKheY/C9kRaK3uty69LL/pvdP8XznumVOw/kpYA2sE
         VgMipgEllEd/ttPMAIMdb0LA8MNGKH5687eUj3ElsdR0CVIJw190Q1NOT1fLqao2Wh
         KB+9LOpGlSijWdeGwP3dQKu3p+MW5rQJJNFmIhUc=
Date:   Mon, 16 Mar 2020 09:20:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Zheng Wei <wei.zheng@vivo.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Allison Randal <allison@lohutok.net>,
        Hanjun Guo <guohanjun@huawei.com>,
        Enrico Weigelt <info@metux.net>,
        Yunfeng Ye <yeyunfeng@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel@vivo.com, wenhu.wang@vivo.com
Subject: Re: [PATCH v2,RESEND] btrfs: fix the duplicated definition of
 'inode_item_err'
Message-ID: <20200316082021.GA3146292@kroah.com>
References: <20200316034600.125962-1-wei.zheng@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316034600.125962-1-wei.zheng@vivo.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 16, 2020 at 11:45:57AM +0800, Zheng Wei wrote:
> remove the duplicated definition of 'inode_item_err'
> in the file tree-checker.c
> 
> Signed-off-by: Zheng Wei <wei.zheng@vivo.com>
> ---
> 
> changelog
> v1 -> v2
>  - resend for the failure of delivery to some recipients.
> 
>  fs/btrfs/tree-checker.c | 4 ----
>  1 file changed, 4 deletions(-)

Your choice of people to send this patch to is very odd:

$ ./scripts/get_maintainer.pl --file fs/btrfs/tree-checker.c
Chris Mason <clm@fb.com> (maintainer:BTRFS FILE SYSTEM)
Josef Bacik <josef@toxicpanda.com> (maintainer:BTRFS FILE SYSTEM)
David Sterba <dsterba@suse.com> (maintainer:BTRFS FILE SYSTEM)
linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM)
linux-kernel@vger.kernel.org (open list)


Please be more mindful.

thanks,

greg k-h
