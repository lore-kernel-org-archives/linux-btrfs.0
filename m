Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EA4C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 11:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630AC2085A
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 11:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hKqPJJc7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfCOLTX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 07:19:23 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:32975 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfCOLTX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 07:19:23 -0400
Received: by mail-oi1-f172.google.com with SMTP id z14so7005007oid.0
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2019 04:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ER5afKJMlBtC45w7KNFHHcU1sNeRMFIS8bt4Wyp12So=;
        b=hKqPJJc7fxskc/CjIi33NBdviR5PjSNcNf5q+faT+iGXYC8yglKfxNhhzqRJS+N55T
         7OQTuvgyTgam2KJaBa2YFVXrtuYOCyo39ASGL4ttssPq4V7+q8myY3nKroJtcj/MXj/B
         4H1xaCAX0KFPCE2DSj/g1IMNQXUuL5mWnC8l2Hw7e/PLw4xhCnbX4yS+cz4e2IV4BnDU
         rLMmeW42Qj5+J4pBbg0GxQ/Qr8GPpA4p56CpoBvFLhKtv4A4PFMqNwyBorj/omF19vHJ
         L9eq9LezhEOQxj634bi496/Ns+W1rcyvmSTQuTXixo3pxX+xapIWmNs5yG/lNywH3VHp
         paIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ER5afKJMlBtC45w7KNFHHcU1sNeRMFIS8bt4Wyp12So=;
        b=C3UhCLCxoHXtIrNumIYTxBYQynwggyZwut0i+17AyXBOSEN2s8POMVCU7YIZUyDTCV
         o+ktdQr689sFitTYlW6L0j5MfCQ/J1FV3pPOTiFKcsAKlabI9l4T66QOu+7F2y1mx9oO
         b/6j0YXEj/9LAhE1QVxv4mKIT1ML76VZMM9hQMEGvLRnIr8yNgOAGgY5yQrENG6ZB4xx
         xp5g3QMgG0cvzNoDleIhWbRVK6W7qhSG6rsUBGCQ249ETPAjPlgC/xwy0aRSP6Y+oqlD
         TQWQJPRXrJAwOp+WQBfexpjUxM3/PYt2di7X3DNt0uVlifUhjroCzzsTC//QvN3RRL02
         L0XA==
X-Gm-Message-State: APjAAAXPk3p8zPZY1XJAagh7NcV8l/Hqbu06oKT9ZraUrSneuDOTufwC
        mO43YJxWDgV5LTW04H8w1nBPkpSidK5BN0z6qTw=
X-Google-Smtp-Source: APXvYqyYGqKtV7V0IOfKKwd6QKOA/VT+3KEQ151JRkyxcdZECfrO0059IhZHyJxXy3Iwjron1X6weq7buH5DA0wWRnQ=
X-Received: by 2002:aca:3bc5:: with SMTP id i188mr1255549oia.59.1552648762724;
 Fri, 15 Mar 2019 04:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtQYezBhv0FvCineu9eTGs9gisyispwDD4wEe-CURVoTCg@mail.gmail.com>
 <010201697e5acc16-2345a495-0bdc-45d4-8363-d4397d9a7841-000000@eu-west-1.amazonses.com>
 <20190315053822.gsqwah5dpp23uimw@navis>
In-Reply-To: <20190315053822.gsqwah5dpp23uimw@navis>
From:   Timofey Titovets <nefelim4ag@gmail.com>
Date:   Fri, 15 Mar 2019 14:18:46 +0300
Message-ID: <CAGqmi74-AjgVrWkj-H9MC_mTdh0t9G-eQzkQsCzEXNiwuWtetw@mail.gmail.com>
Subject: Re: psa, wiki needs updating now that Btrfs supports swapfiles in 5.0
To:     Nicholas D Steeves <nsteeves@gmail.com>
Cc:     Martin Raiber <martin@urbackup.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

FAQ updated.

Thanks.

-- 
Have a nice day,
Timofey.
