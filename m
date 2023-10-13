Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D35CDB47E
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Oct 2023 13:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjJMNx1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 09:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjJMNx0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2023 09:53:26 -0400
X-Greylist: delayed 525 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 13 Oct 2023 06:53:24 PDT
Received: from vps.thesusis.net (vps.thesusis.net [IPv6:2600:1f18:60b9:2f00:6f85:14c6:952:bad3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E3EAD
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2023 06:53:24 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id D3FE61447E2; Fri, 13 Oct 2023 09:44:38 -0400 (EDT)
From:   Phillip Susi <phill@thesusis.net>
To:     jlpoole56@gmail.com, linux-btrfs@vger.kernel.org
Subject: Re: SanDisk Extreme Pro w/btrfs Frozen: nodiscard per Western Digital
In-Reply-To: <2a56e458-88eb-43bc-94bf-9b5a4886d90f@gmail.com>
References: <2a56e458-88eb-43bc-94bf-9b5a4886d90f@gmail.com>
Date:   Fri, 13 Oct 2023 09:44:38 -0400
Message-ID: <874jiuhc1l.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

"John L. Poole" <jlpoole56@gmail.com> writes:

> PARTUUID="426c28a1-02"  /       btrfs   noatime, [LINE BREAK]
> compress=zstd,ssd,discard,x-systemd.growfs      0       0
                                            ^^^^^  ^^^^^^
What are these goofy characters?  They just show as solid blocks to me.

>        Use the nodiscard flag.
>        Command: $ mkfs.ext4 -E nodiscard -F /dev/mmcblk0p1
>      [--- end response ---]

I wonder why they say to use nodiscard?

>      # create a test file of 512 zeros
>      date; time dd if=/dev/zero of=/tmp/1_block-512_zeros.raw count=1
>      # write test file to card
>      date; time dd if=/tmp/1_block-512_zeros.raw  of=/dev/mmcblk0

Rather than copy /dev/zero to a file, then that file to /dev/mmcblk0,
you could just dd directly from /dev/zero to /dev/mmcblk0.

