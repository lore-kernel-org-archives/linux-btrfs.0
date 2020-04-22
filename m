Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CE8C55185
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 14:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F062082E
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 14:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="xmRkQL58"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgDVOto (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 10:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgDVOtn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 10:49:43 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BEFC03C1A9;
        Wed, 22 Apr 2020 07:49:43 -0700 (PDT)
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id C771814133A;
        Wed, 22 Apr 2020 16:49:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1587566980; bh=K82WD5SMGnPO0Iqk/V4GNqrcK3kJVchQaCY5P8RgEl0=;
        h=Date:From:To;
        b=xmRkQL58Xu4frKEQ/Z71X4L4j1YlimJ9gZTs8o1Ik9gZH3N1veqcuyfg2UyfW1l/m
         WVfUeAQFjIYjZM8eOKhvrWXBcoEYwjZgGxqbW6sO1kjygUyv0DtRxPhamuQA24ruRM
         0/KZ2CtOi8sitTxnOV8bSN9hPbcGpqe4lgu/jzz4=
Date:   Wed, 22 Apr 2020 16:49:40 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Su Yue <Damenly_Su@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, u-boot@lists.denx.de
Subject: Re: [PATCH U-BOOT 18/26] fs: btrfs: Implement btrfs_lookup_path()
Message-ID: <20200422164940.2d8e32d7@nic.cz>
In-Reply-To: <tv1binqc.fsf@gmx.com>
References: <20200422065009.69392-1-wqu@suse.com>
        <20200422065009.69392-19-wqu@suse.com>
        <tv1binqc.fsf@gmx.com>
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

On Wed, 22 Apr 2020 22:44:43 +0800
Su Yue <Damenly_Su@gmx.com> wrote:

> Looked through older codes, should be "symlink_limit - 1"?

OMG yes :) without this it can break :)
