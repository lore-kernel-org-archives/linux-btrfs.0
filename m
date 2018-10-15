Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F325DC04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 21:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AABD4205F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 21:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7YPiIZn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AABD4205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbeJPFNF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 01:13:05 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:33495 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbeJPFNF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 01:13:05 -0400
Received: by mail-lj1-f177.google.com with SMTP id z21-v6so18895923ljz.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 14:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1pQEmVE6u/jf1I6FaQPrWpRoiE5eLPwLGCjyZIKH508=;
        b=a7YPiIZnUZBrwHwOy6oQBrt2KFsJ3IXGFugiYy/5QQjiJrPwauJCR+novfi5Ky6839
         dWaVCrko8mm1akIIkgPmnawP4wlE+MbukydYBNPMpUId8pKRJ362rrgDnFYlYwEGEMw3
         5io9PyhhtKtmbJ71saZOV/4ql7xV5MQuuUwfYzmk5lRlNZbOwFvXuUahfBZIBLNQNFY5
         LzqMoXWchRYxRdZ/e0W+FQijTFfJ/2zaFRsLX11blIXPiU7mT//JQ2LkzaswXWo+ubsJ
         /2fTbH0Tn3GwTyNjW64FFWBcr+pSv3ZgvDu3nLYu334h9ol4i91Tj8ycoQgBUPZ/LxFw
         Ce8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1pQEmVE6u/jf1I6FaQPrWpRoiE5eLPwLGCjyZIKH508=;
        b=DRBVvUBqvWUNW/LYEioFkyC1TBDV3nRll0r2p3dHTvZdRX+Vp1+IjgLfa4a7tDYlNi
         f2LMfGM/+J/yt0xNN5fNBD00dcmWwE3R4JB3DoMh5MiANAl45UKRKQ4MZ2luDSQmWaDk
         saLt2z4VswWwMERB4Yrt/dNVtWsLLs6ETH2KwPgFLlBOL4njPIhmwrRqKJ5sQfqbkObm
         U2dmGklPxEUBmfy3U82qobB1YmERTF4833dVwBNQbnK9RvYYpHKZ5TNfkz7FusazNfqV
         eDGL8mBpWf1w2ISEl4FW2OC3cR7JKOZW/BDNlJjjBsaCxTsgrWKdmv4gqycZEHU5IoN+
         xnlA==
X-Gm-Message-State: ABuFfog0TBh2N99x6OFI1sOZN5woKL2E/pnxXMx+levS/l2cDI5PPUji
        SxduO/gTSL1U6UBKhGKHLRc=
X-Google-Smtp-Source: ACcGV63E2Il+4WdfsYmrAQ7Jim7+oMV2PEWzel7joaw4eAbmlJXoB16CJ2Umd2samzkjFomaPs1Zcw==
X-Received: by 2002:a2e:4b11:: with SMTP id y17-v6mr11752303lja.42.1539638763062;
        Mon, 15 Oct 2018 14:26:03 -0700 (PDT)
Received: from ant-519666801b8 ([95.72.235.248])
        by smtp.gmail.com with ESMTPSA id i66-v6sm2683501lji.88.2018.10.15.14.26.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 14:26:02 -0700 (PDT)
Date:   Tue, 16 Oct 2018 00:26:01 +0300
From:   Anton Shepelev <anton.txt@gmail.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Spurious mount point
Message-Id: <20181016002601.5517a4ea66c2c9c5dbdb5471@gmail.com>
In-Reply-To: <CAJCQCtSz+=uwXUFGxagoUOYxy99eCJGG-ezLVh0RO=vL=LReEg@mail.gmail.com>
References: <20181015180546.4dd598bf0fe61b61f56e99ce@gmail.com>
        <CAJCQCtSz+=uwXUFGxagoUOYxy99eCJGG-ezLVh0RO=vL=LReEg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Chris Murphy to Anton Shepelev:

> > How can I track down the origin of this mount point:
> >
> > /dev/sda2 on /home/hana type btrfs (rw,relatime,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot/hana)
> >
> > if it is not present in /etc/fstab?  I shouldn't like to
> > find/grep thoughout the whole filesystem.
>
> Sounds like some service taking snapshots regularly is
> managing this.  Maybe this is Mint or Ubuntu and you're
> using Timeshift?

It is SUSE Linux and (probably) its tool called `snapper',
but I have not found a clue in its documentation.

> Maybe it'll show up in the journal if you add boot
> parameter 'systemd.log_level=debug' and reboot; then use
> 'journalctl -b | grep mount' and it should show all
> instances logged instances of mount events: systemd,
> udisks2, maybe others?

I will try that as soon as the client lets me reboot that
machine.

-- 
()  ascii ribbon campaign -- against html e-mail
/\  http://preview.tinyurl.com/qcy6mjc [archived]
