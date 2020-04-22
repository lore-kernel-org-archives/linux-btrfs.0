Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0853C5518B
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 07:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A56A0206E9
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 07:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="jYxWAJwE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgDVHqM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 03:46:12 -0400
Received: from lists.nic.cz ([217.31.204.67]:44682 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgDVHqL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 03:46:11 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 7064513F7F8;
        Wed, 22 Apr 2020 09:46:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1587541569; bh=/oDiupn/mTAclohZx7XI0pHwaADzqQyl/21YtK44EaQ=;
        h=Date:From:To;
        b=jYxWAJwEyP2+19xvwPraDFbo6Snd5xZpc3NVkdAjo5tBPCNJ8SlH0yqhhYcdO9P9k
         qOA7EPp+i0+j7+8uYrUhYQWblCpEnAgksGWD9ljsCVrnBI06IuL/5b8AQxhgFW0WhP
         yx6apS2Q3j6njBJBnNr/dgpNPJgOxoP8FJgPzmQM=
Date:   Wed, 22 Apr 2020 09:46:07 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH U-BOOT 00/26] fs: btrfs: Re-implement btrfs support
 using the more widely used extent buffer base code
Message-ID: <20200422094607.1797ce2e@nic.cz>
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

On Wed, 22 Apr 2020 14:49:43 +0800
Qu Wenruo <wqu@suse.com> wrote:

Hi Qu,

> The current btrfs code in U-boot is using a creative way to read on-disk
> data.
> It's pretty simple, involving the least amount of code, but pretty
> different from btrfs-progs nor kernel, making it pretty hard to sync
> code between different projects.

do you think maybe btrfs-progs / kernel would be interested if I
tried to convert their code to this "simpler to use" implementation of
conversion functions?

> Thus only the following 5 patches need extra review attention:
> - Patch 0017
> - Patch 0018
> - Patch 0022
> - Patch 0023
> - Patch 0024

Anyway, this patch series does not apply cleanly on u-boot/master. I
tried with the first 3 patches and then gave up :(
Sorry about this but I will review and test if you send a series that
applies cleanly.

Marek
