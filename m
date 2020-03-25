Return-Path: <SRS0=KM0e=5K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE2CC1975A
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 08:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2431420772
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 08:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="AGSA5o/E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCYIFt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 04:05:49 -0400
Received: from mail.nic.cz ([217.31.204.67]:45508 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgCYIFs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Mar 2020 04:05:48 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2020 04:05:48 EDT
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 3660A1431A3;
        Wed, 25 Mar 2020 08:58:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1585123134; bh=i221D3Q2tKsSMzKXdKG/NnLEORBQ6FahYSxTOlRSdzo=;
        h=Date:From:To;
        b=AGSA5o/ET4bDh2j8srCT5MznO5fFjnUeXb4Y8P1JMKvtzEEIPdMG8RTC5c9yxU5QH
         w2qsMiucjD3NQuHZy7q9jlfAlG2zsVgnLgu8FxfxM11+Bc0aLGb7drpRZbYpGsbg9c
         Apser9k7FzC3MTvR5ATxPN4ou3jA//tuitJhB4Mc=
Date:   Wed, 25 Mar 2020 08:58:53 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Matthias Brugger <mbrugger@suse.com>,
        Qu Wenruo <wqu@suse.com>, u-boot@lists.denx.de,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] uboot: fs/btrfs: Fix LZO false decompression error
 caused by pending zero
Message-ID: <20200325085853.618551ca@nic.cz>
In-Reply-To: <0e17f85f-46ab-2c2b-1547-3ef6b8b81d93@gmx.com>
References: <20200319123006.37578-1-wqu@suse.com>
        <20200319123006.37578-3-wqu@suse.com>
        <49c5af50-8c09-9b49-ab44-ebe5eb9a652c@gmail.com>
        <20200319135641.GB12659@twin.jikos.cz>
        <46e58bc7-4a4c-fa2a-33cd-0e8df65d6bac@suse.com>
        <20200319162822.GG12659@twin.jikos.cz>
        <0e17f85f-46ab-2c2b-1547-3ef6b8b81d93@gmx.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 24 Mar 2020 19:03:30 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> Sorry for the delayed reply. (Stupid filter setup).
> 
> Currently most Uboot boards should use the same page size setup for its
> kernel, and most btrfs uses 4K sector size.
> 
> So for Uboot it should be no problem.
> 
> Although the best practice is to read the fs_info::sectorsize as David
> mentioned, but the code base doesn't allow us to do that yet.
> 
> So I'm going to backport the read part code from btrfs-progs in the
> near-future, and completely solve it, making it sector size independent.
> 
> Would this plan looks sound? Or we need to wait for the full
> re-implementation?
> 
> Thanks,
> Qu
> 

The situation is Linux is such that btrfs sectorsize must be same as
PAGE_SIZE, otherwise the Linux btrfs driver won't work. AFAIK there are
only few architectures where PAGE_SIZE is not 4 KiB. btrfs filesystems
created there cannot be mounted on systems with PAGE_SIZE = 4 KiB.

I don't know if U-Boot is used on non 4KiB PAGE_SIZE boards. If it is,
it should be solved, but I would check that before complicating the
code.
