Return-Path: <SRS0=9zy5=PO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF11C43387
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Jan 2019 17:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A8F32085A
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Jan 2019 17:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="anu6fvPR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfAFR54 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 6 Jan 2019 12:57:56 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36947 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfAFR54 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2019 12:57:56 -0500
Received: by mail-wm1-f67.google.com with SMTP id g67so5444420wmd.2
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2019 09:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2V7hrgE4sxl1CdRAS5Jm2RX1YMzrYDf/ASL7p/hhYnE=;
        b=anu6fvPRWIfOTX4T+8UtqID6IJ5rXNj7FsIgTwLeP1YgaXEF4IkxFd4oudYSYVZnNZ
         Kqqs1nXEZFM2aqgES7vY4GUtPxQaA6ukHUkkPczFRY3CZzb77ldTat7bIB9bnnh5U6Yd
         yncCU4ehgb7dvOofyByOjCbWi+jjl3QtW8Vc2tef1arL15/OwyxrAZBakvpO/Rh6Oq4G
         i39Kgjd7msdE7JtccR5aiVFhqnkstwh9M1dmQ9YfHR+xLcC1i939hS/MFceWlH32PIOc
         3DJieu4SxVeo9Rc7VU+ZBSziSNY8xUWR2qiUVJXJ/qqcDp6+yKH4ytMyt0rZOGZPaSLk
         GoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2V7hrgE4sxl1CdRAS5Jm2RX1YMzrYDf/ASL7p/hhYnE=;
        b=pIDG59qCCR7sLOQf8hojGIvL5dTM7VxBsqT2HXbFcfqlPUaeV5Ius5trSQh1H8XNQ6
         GHN7ZlRVqzlZ9CE9nScTBfSbgA/6SIrN5bwQBzsybcTtDg8jinJx30aMA9ME70Hz8tDu
         YaLOHvBOOKSzVXkOSwiVL1ni6XEQcTIjm3l/y8gYqLv+bWlhCvbULHe1ZFZ0pgRLwEs1
         n6ANIeiU166XPEeAs116prlOeCxe9rbdLgpZwBRR8tflzIegXWPrUCB1Ye+7hKxTnDqD
         TUiPbT+6Rc4jl4pnmvx4FNHSVYRlvTmD3WUvw5PO1U/Fc2NBAsxtEy5rEIrZzyrcQBn8
         /LTQ==
X-Gm-Message-State: AJcUukeJver2C/4wP0qgrYIVhwKKbLy1yd35jx614mfwK5E9OXE3Sr8d
        Vxyd0SjDPOM1TSU25xnhNCg=
X-Google-Smtp-Source: ALg8bN5Ddo7exsCc26Jbuy+LDicCajrHQVjKoFjch9JnkqIIFAmceoCrZfFprRpB14Zccfwcva7moA==
X-Received: by 2002:a7b:c5d1:: with SMTP id n17mr6626962wmk.152.1546797474712;
        Sun, 06 Jan 2019 09:57:54 -0800 (PST)
Received: from exnet.gdb.it ([5.90.195.121])
        by smtp.gmail.com with ESMTPSA id j3sm6295659wmb.39.2019.01.06.09.57.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 06 Jan 2019 09:57:54 -0800 (PST)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
Date:   Sun, 06 Jan 2019 18:57:08 +0100
Message-ID: <2025891.FNXETDMuRi@exnet.gdb.it>
In-Reply-To: <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com>
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <2971657.kkKnYu9ILp@exnet.gdb.it> <dc635a98-32cc-4f84-2319-82ef651d3f49@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In data domenica 6 gennaio 2019 15:12:38 CET, Qu Wenruo ha scritto:
]zac[
> Do you have a full history of the kernel versions?

I believe from version 4.13.9 to 4.17.7 .
Today I updated everything to fedora 29, kernel 4.19.10 .

> I'm not sure when the corruption happened.
> It's completely possible that some old kernel caused the corruption but
> not exposed until now.

I am quite convinced that it happens during the snapshot delete and the 
subsequent cleanup.
And maybe even the umount is part of the problem.

> Also, would you please run "btrfs check --readonly" on the fs?
> It should show all corruption.
> 
> And if "btrfs check" shows no corruption, then it's completely a bug in
> that given kernel (and even current kernel).

btrfs check reported various corruptions and fixed them.
A this time it seems that the filesystem works fine (it's the first time it 
does not have to be redone from scratch).

> Thanks,
> Qu

No, thanks to you for your work.

Gdb


