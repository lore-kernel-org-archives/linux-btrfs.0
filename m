Return-Path: <SRS0=NMa+=4O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED952C4BA0B
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Feb 2020 03:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6CC62067C
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Feb 2020 03:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t0u8vZK0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgBZDoz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 22:44:55 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:39276 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgBZDoz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Feb 2020 22:44:55 -0500
Received: by mail-wm1-f54.google.com with SMTP id c84so1430208wme.4
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2020 19:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZFfb47Tk27/0G6pO9r4ax6BeH7VyS2RX0e+5N8cSfGU=;
        b=t0u8vZK0iQl2vQHIKlMAaVIb2FcJwmYOGGuLVbctX2T5QRUMG28S2GvyKZOfY0d0um
         x5kaGZy+qzfJYtx32aGnPoL5z2w4rovlxdiWfINMPLxCz4Fd8H9coHFO8BTTKI0qlQZN
         80E+XE/RGVhU1253J64ZXiCySAqJ2+3ggLuWYt4sGgaqH778BGMr2qTiSEuxFHNXuK6o
         +L3aZs8P2B4u8IoQsmkbhhl/Mu1uP6LNKWPwLYM3DoMuHoK3dzkpP/wAl2PX4Rs2G3Z0
         tt2YV67k/sltM/p+2NmQOq0ECw2dOOMjJJkIOu1dRdUEJBtl3WW/XFjRokutUqwg/DTe
         an3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZFfb47Tk27/0G6pO9r4ax6BeH7VyS2RX0e+5N8cSfGU=;
        b=pro2lECDq2ECWxxTz9AQQ4xd7uo0HUZoWOoL+JeThm4bwQ17postR+FXJJcbIg0rfX
         NK9L+8T55+VKw4hRsJ/gSt9FmmxVpyTKLLImGg3ss7L+NTKLZj7rDYcHIB4A8jCMcZ62
         0oa0Wy90tSitz8ffBdclANpWOrdG1BEAHpSX1twpow1wL1PXdaeh8MjIuegTm0f4svna
         bF0Jx8ILvYS+oTlzzfn+Vqu/R4X092ah/EdWHNtkDBALDcDTF0c23VWY1j+oMgLh3KrG
         J6adcfL657/tDf5qG8TxKP+Jw0n61+95oUXAHiSdJPhqJoUozlBHhiDxO8HxUWk+zSfU
         UGsA==
X-Gm-Message-State: APjAAAX+I20OvRwabAs3hVoKyD2c08QSJG9g5uEtBg7InvO1lG94qQdm
        LlGkiluewSzncaedddAuz8xnunDd1VEzc8cA4kFsdiA=
X-Google-Smtp-Source: APXvYqwy5ySSZ3ceUX528BdSLyM2HnnLigLC5YeEbJ6/Z2EDLobfZ33K1BotnmY3GnlemEcoo/M3WYyER+BMzlGAfyA=
X-Received: by 2002:a1c:f712:: with SMTP id v18mr2799716wmh.155.1582688693991;
 Tue, 25 Feb 2020 19:44:53 -0800 (PST)
MIME-Version: 1.0
References: <CAAW2-ZfunSiUscob==s6Pj+SpDjO6irBcyDtoOYarrJH1ychMQ@mail.gmail.com>
 <2fe5be2b-16ed-14b8-ef40-ee8c17b2021c@gmx.com> <CAAW2-Zfz8goOBCLovDpA7EtBwOsqKOAP5Ta_iS6KfDFDDmn47g@mail.gmail.com>
In-Reply-To: <CAAW2-Zfz8goOBCLovDpA7EtBwOsqKOAP5Ta_iS6KfDFDDmn47g@mail.gmail.com>
From:   Jonathan H <pythonnut@gmail.com>
Date:   Tue, 25 Feb 2020 19:44:27 -0800
Message-ID: <CAAW2-ZedO0UmG7eapyyGmU18dM-4xbO64wcVoXOiW1saB69zVA@mail.gmail.com>
Subject: Re: USB reset + raid6 = majority of files unreadable
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 25, 2020 at 7:38 PM Jonathan H <pythonnut@gmail.com> wrote:

> Here is the output from "btrfs check --check-data-csum": http://ix.io/2cH7

Whoops, it's actually at http://ix.io/2cGZ
