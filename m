Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FDCC433EF
	for <linux-btrfs@archiver.kernel.org>; Sun, 12 Sep 2021 11:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D40F60F43
	for <linux-btrfs@archiver.kernel.org>; Sun, 12 Sep 2021 11:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhILLB5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 12 Sep 2021 07:01:57 -0400
Received: from mail.linuxsystems.it ([79.7.78.67]:56346 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhILLB4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Sep 2021 07:01:56 -0400
Received: by mail.linuxsystems.it (Postfix, from userid 33)
        id EDE86210237; Sun, 12 Sep 2021 12:44:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxsystems.it;
        s=linuxsystems.it; t=1631443495;
        bh=GUPFyPPZByD1kCrEIpUyl/oJMXCRB/orxT3wRSuYrVk=;
        h=To:Subject:Date:From:In-Reply-To:References:From;
        b=BnE3fezEEYx50QkW7s1SALIym4Ee9ZAAmZlsjb0qAqWsOaxHgDAyejF9VeS78SoGg
         V5jkIBuVRDR0ylB3YsoeTEU3IfOiHO1Fqa6Zg9GDc8Nz1PJ1Ix/i//gH2xV0gB2r6L
         +XOsiaet3rnB02xWZ1ZAz+lUvW6V3OMdkdomqQKs=
To:     linux-btrfs@vger.kernel.org
Subject: Re: Unmountable / uncheckable Fedora 34 btrfs: failed to read block   groups: -5 open_ctree failed
X-PHP-Originating-Script: 0:rcube.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sun, 12 Sep 2021 06:44:55 -0400
From:   =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
In-Reply-To: <0303d1f618b815714fe62a6eb90f55ca@linuxsystems.it>
References: <0303d1f618b815714fe62a6eb90f55ca@linuxsystems.it>
Message-ID: <a38098d2c2cf96c367707635791b06f9@linuxsystems.it>
X-Sender: darkbasic@linuxsystems.it
User-Agent: Roundcube Webmail/1.1.5
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Il 2021-09-12 06:27 Niccolò Belli ha scritto:
> I did manage to recover some data with btrfs restore (no idea how much 
> of it):
> 
> $ sudo btrfs restore /dev/nvme0n1p6
> /run/media/liveuser/3ea0705c-21c9-4ba9-80ee-5a511cb2a093/nvme0n1p6_restore/
> Skipping snapshot snapshot
> [...lots of snapper snapshots]
> Skipping snapshot root

I just noticed it completely skipped to restore my root subvolume.
Maybe because it was originally restored from a snapshot (during a 
previous btrfs corruption issue) and so somehow it thinks it's still a 
snapshot?
How can I restore it? I cannot afford to restore all the snapshots, I 
don't have enough free space to do so.
