Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD32C432C1
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16884214DA
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 13:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="d4wS9RRq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505046AbfIXNWW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 09:22:22 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:45975 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbfIXNWW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 09:22:22 -0400
Received: by mail-qk1-f175.google.com with SMTP id z67so1661144qkb.12
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2019 06:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1nJ3hJgxUDeB/eDZ/37tOSrHXptXXPDIIIYZ3WNTRoM=;
        b=d4wS9RRq5xL5lka3efKR8kO6KhZ+UmTCCn6z1asiej/kURKNtm/ma3gkUAXQEUD8CW
         RrGAWn8/xkySy1Tp+rUu3lEYNMK8+s6fU+8BsXbJXT8m2bVNMRKjpT84nW5NVyQUO8bN
         2tsx2BK6v+HMWgEv6cwrq7YMvav4fixOmV1ZDcvDyqYFC85DBPRQsckILstYVIO5lbg3
         fp1uc2TcZbNBEhdL98M1oI1nDzKE1wb/B4m/StrP3F01cb3nO78LYrgYJnPtaOBVxd2c
         5fC15UTPnREXH2fP8/JaQHxs1W4nm4WCEauQJuNExY9J/yzesTuFbEEA9rasWH0+chdY
         Yw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1nJ3hJgxUDeB/eDZ/37tOSrHXptXXPDIIIYZ3WNTRoM=;
        b=fAuq2Yc5llcU1eGhKuXtMF8aNKo262VRWKqNE6C/3bqNJKdanUEtOSK2oJJPn7ibUE
         ZV5SdpFn3aIdXNoLGSwOFNfQRKtE3cKLL+K3aoppvhM7kSO/LKHQJhi/nq5yFF/TxuFB
         7y2lKrS+BowfkPnY7YJ0di4w6PNakuUrqreY6Qdhbh3X0epmXanPk3sUN0EwF6Jpy0G9
         xA5ccGpoOonr/BzwkPzF8ve1uyFJa6az5kXniIQ/mF/rBa4J4PRUB0J/OW0bgASaCv8j
         WgOcjjNauiItg8x4ku0Jku397FEangCGaMIIEtSXdNiZJyRMmZ+xceA0HKnkiVrHEVK0
         MtcQ==
X-Gm-Message-State: APjAAAXbH2ji5+NlWejun+uRDA4u6Edgid2blO49wJ82n3VVRAuEi4/w
        XOhkC9eMURhYHDcjforXkK7mkAQbrH6gIw==
X-Google-Smtp-Source: APXvYqwBBVjC/nT7Dj8CCzyXflps2PQH87gKl3Rnzpxy8ts5a5gQjFWBxcPAr2vkCLN/zfH636RkoQ==
X-Received: by 2002:a05:620a:6cf:: with SMTP id 15mr2316454qky.112.1569331340321;
        Tue, 24 Sep 2019 06:22:20 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::b7c9])
        by smtp.gmail.com with ESMTPSA id g33sm972294qtd.12.2019.09.24.06.22.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 06:22:19 -0700 (PDT)
Date:   Tue, 24 Sep 2019 09:22:18 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Pete <pete@petezilla.co.uk>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Balance ENOSPC during balance despite additional storage added
Message-ID: <20190924132217.44jhtgrk7f7bwysb@macbook-pro-91.dhcp.thefacebook.com>
References: <94ebf95b-c8c2-e2d5-8db6-77a74c19644a@petezilla.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94ebf95b-c8c2-e2d5-8db6-77a74c19644a@petezilla.co.uk>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 20, 2019 at 03:29:32PM +0100, Pete wrote:
> I have a btrfs that is on top of an lvm logical volume on top of dm-crypt on
> a single nvme drive (Samsung 870 Pro 512GB).
> 
> I added a second logical volume to give more space to get rid of ENOSPC
> errors during balance, but to no avail.  This was after I started getting
> enospc during balance.  Without this additional logical device, before
> balance, I had run out of space owning to some unfortunate scripting
> interacting with lxc snapshots (non btrfs backed in the config, so a copy)
> and some copying.  I was performing a balance, following some deletions,
> when trying to get things back to a better state.
> 

Just popping in to let you know I've been seeing this internally as well, I plan
to dig into it after we've run down the panic we're chasing currently.  Thanks,

Josef
