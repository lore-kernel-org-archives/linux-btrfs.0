Return-Path: <SRS0=kS6Y=VV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB7CC76186
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jul 2019 22:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF44E21850
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jul 2019 22:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4jhYx8U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfGXWZ1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jul 2019 18:25:27 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:43088 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfGXWZ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jul 2019 18:25:26 -0400
Received: by mail-wr1-f44.google.com with SMTP id p13so48544731wru.10
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jul 2019 15:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DPc2yEcgq/b9vFg2Z8md/oUGvl79yEGfi4JLqxoFpQc=;
        b=H4jhYx8UbehkrHcMRO6KDhXWx+B4y/2Uj02LZy5ZfkdGGCPSz/T+/Vcr0T9eg4ofQG
         OGFjus/zvSoc2QMeRUvNSsbx6nHyedhWhkdUyl+0YVbTOtYgm6PrSdi2I+uueWA4SGg9
         jVrtXr7+iOj0SlqTlMkMgMroEzxzDtnG2TRNO+0kvPjIYi3G8M1MlNdnJkNu/zbpFsXX
         pCYvLLrH3PD/YAc2kkMgSaf6r9QSOHCOK5z6oHO2e2UdpUnH1zqXw82Eh5g9P8na6WjU
         dVeHb6Xe97ZlmXooApXPA02a5G6CHxIvkmN69vy1V2NYM7iN7a8fwIuhB0GzkAKda944
         TTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DPc2yEcgq/b9vFg2Z8md/oUGvl79yEGfi4JLqxoFpQc=;
        b=G5AUt4haggqhzjm5nd/Nt8lbHMsTazoh94VomnONVubYYBBMlY2sOC2lcG20rouDOZ
         2/LDzm+UszyTIqtEdQmEAv8yWl80elQy8kCP7U51G2bUBX58nWo60LUaJcsScYUcezEc
         hpIF5OCTndHtHDqVRUjkYz0S5FY66GRK0kKdx6dTsUw6Z8N5Qx6WcOmItpWzsAAh3QSB
         DrLFEdgTdNNHYDPKXKdnhI3EAlfIma92h336yI4YLEDqldKxM7bPpSyoLlc4C8ljfYDB
         4ubb3l3Xn7hFnGQsaGiKQfzYUjbvP6Ov77krVqSjpADa8DmhYfsOQES1ZTbbPlk4miQn
         Z8rA==
X-Gm-Message-State: APjAAAWH0PXs5xHTVDaGwHAASV6B8aK9SI1tzzbTR/WG2/cMuYfFBIbY
        vaSEwOo2FXfYs4sjQmRkEcp6+Y6b
X-Google-Smtp-Source: APXvYqw64KakGaoiEBYe+78yu/LY+xlsdfPqP9raMSXbYPh522Gv7ZBNo2GxF/dIJS3+O1QBnMmxIw==
X-Received: by 2002:adf:f601:: with SMTP id t1mr90210072wrp.337.1564007124605;
        Wed, 24 Jul 2019 15:25:24 -0700 (PDT)
Received: from archlinux.localnet (65.red-83-34-150.dynamicip.rima-tde.net. [83.34.150.65])
        by smtp.gmail.com with ESMTPSA id o6sm92167076wra.27.2019.07.24.15.25.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 15:25:23 -0700 (PDT)
From:   Diego Calleja <diegocg@gmail.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: extent-tree: Add comment for walk_control to explain how btrfs drops a subvolume.
Date:   Thu, 25 Jul 2019 00:25:18 +0200
Message-ID: <3769531.JR3RUOJnLt@archlinux>
In-Reply-To: <20190723075721.9383-1-wqu@suse.com>
References: <20190723075721.9383-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

El martes, 23 de julio de 2019 9:57:21 (CEST) Qu Wenruo escribi=F3:
> + *       A	<- tree root, level 2
> + *      / \
> + *     B   C    <- tree nodes, level 1
> + *    / \ / \
> + *    D E F G   <- tree leaves, level 0
> + *
> + * 1) Basic dropping.
> + *    All above tree blocks are owned exclusively.
> + *    Drop tree blocks using LRN iteration.
> + *    Tree drop sequence is: D E B F C G A.

Excuse me if I am wrong, but there seems to be a small typo, shouldn't
it be "F G C"?


