Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC450C5518A
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 07:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B5E20738
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 07:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="QStaCGZb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgDVHwI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 03:52:08 -0400
Received: from lists.nic.cz ([217.31.204.67]:46104 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgDVHwI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 03:52:08 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 3D20613F7F8;
        Wed, 22 Apr 2020 09:52:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1587541926; bh=O7BuoCFle2WiUETAFFYLyXYIkbkXV/0mKewlKtPKJtw=;
        h=Date:From:To;
        b=QStaCGZbcc8YI4CQ8hvIfQ/WYIAM6pY1wLZbDBWkw7AggzzbvXFE58z6s1V6GeFQh
         4Zw3SLjV0qIGy9sRl7IKRToy4DMf4WLHocDUxiap6E992Lp/x3jxS+dlxxLLmgNXvv
         +D4YJLSjjRGb4ThhYo4Ephlnm6uUPbXta3VVQPVc=
Date:   Wed, 22 Apr 2020 09:52:05 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH U-BOOT 00/26] fs: btrfs: Re-implement btrfs support
 using the more widely used extent buffer base code
Message-ID: <20200422095205.112a9a79@nic.cz>
In-Reply-To: <20200422065009.69392-1-wqu@suse.com>
References: <20200422065009.69392-1-wqu@suse.com>
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

I am testing compilation from the github repository.

Another problem is that in the cleanup patch you have removed
btrfs_list_subvols functoin, which is used by cmd/btrfs.c to list
subvolumes. So Turris Mox and Turris Omnia with their default defconfig
do not compile now.

Marek
