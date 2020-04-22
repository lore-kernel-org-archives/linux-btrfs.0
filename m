Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE90C54FCB
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 18:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A8652076E
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 18:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="R8hBWsm+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgDVSwM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 14:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgDVSwM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 14:52:12 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F2CC03C1A9
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2020 11:52:11 -0700 (PDT)
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id AA8D2140BC2
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2020 20:52:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1587581529; bh=UrsPs8jNrsz7Px784nikxDT36F/VadRKL4cR/cg8sxo=;
        h=Date:From:To;
        b=R8hBWsm+pEkxyuMMipr/JdAM1I2tcW+YQW3vDflBpVAhSGya7DF2cNcGI/Uh3qZdN
         dBGQhSMcBpzvlQx/dXP/cY/NMp5go4vYkna7/ioq0vAWLEKmnCHCl0vGBfmlcChXyU
         bAhMV5z85+1g+IYSVIqwVF2yERefD58HF9o1OGJs=
Date:   Wed, 22 Apr 2020 20:52:09 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     linux-btrfs@vger.kernel.org
Subject: when does btrfs create sparse extents?
Message-ID: <20200422205209.0e2efd53@nic.cz>
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

Hello,

there was a bug fixed recently in U-Boot's btrfs driver - the driver
failed to read files with sparse extents. This causes that sometimes
device failes to boot Linux, since the kernel fails to load from
storage.

So when does kernel's btrfs driver write sparse extents? Is it always
when it finds a PAGE_SIZEd and aligned all-zeros block? Or is it more
complicated?

Thanks.

Marek
