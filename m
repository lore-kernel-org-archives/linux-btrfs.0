Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A24C04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 12:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0816E2084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 12:45:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VcNsjrEI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0816E2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbeLLMpI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:45:08 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:40540 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbeLLMpI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 07:45:08 -0500
Received: by mail-wm1-f48.google.com with SMTP id q26so5776976wmf.5
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 04:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=rHODSX/ff3UDG34CS8pW3jtYOa7VyaofS5+Yuvo+bcg=;
        b=VcNsjrEITVFYdqdMOKPc1HUgg2/f64CrUNtCIVm7zj9RmxEpH+BEJ4zNIswfOf/Uem
         beEM3Sfh7/vbdVkjzvSgvg5qFugksJiMfArM/i/brPqQl0+CrXKnbQwiNtEU6il27T8M
         aBSMK6oYfGrgRcsZfmUEA+t+LZVg4SlujDyG443+Gh2YKpFe/JDToklFOsuuXe/6lYOP
         xLcaEFiwQf2iDkb84tQguiCa0yLlovUtyl+41HpQTnHmgfkevf/Yd4NqmFHcH+a7Iuia
         wlGEAR/eXYlHb95sc/AIspWiuylDWd8NJntKDcg4GJ8ONWW8V+Orzg8JNx7oeWCq99oC
         iVvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rHODSX/ff3UDG34CS8pW3jtYOa7VyaofS5+Yuvo+bcg=;
        b=LEP6eRHvgZeRYYHsneJfxwPicxGADpVr8aciKwBqzkXK3RT+rbZosiYVyUmPveOj+h
         WVkBWJhATCXK4KGWqtzvMfRaor+IWN8eEfG0bgdBaY4kvsQ+8cPeJMJka4qbMZ06Tbr+
         VG4cDgpY3O/NXMtW4IlE/4tunTvuTzks4/pEZ3uYfq4qwJvIp/zYAcn58ux1rRL2HNE0
         tEVwQyRnDLf1Rl5jZSJPdicCPPSslTfTTUdfFAhFg69nBQ1BbAMmN785ohCXAJuLBmpY
         p8iNzEWHT1AO1/SA4Y37mRAVFpHYWht0KJ8Wh2Lr97EeQ7WLW4KGZV52RoP76sH30XvX
         n2Aw==
X-Gm-Message-State: AA+aEWayCeQwHEcZUl7rKUV77uifiOfCyjk3IekvVHRa6ojCU4i+yJ2v
        437VZyODf9AeQ+dFI8Ly6eCBuDXzcqOcuppBHT1OlVdG
X-Google-Smtp-Source: AFSGD/VH2UYV1sBIygWSJkf1tyDmIMYYNAtTyH6fmIGR4qGmZeFhdGjm5KxBuJBr961shD48su2ncSBULHAVm4XOPCI=
X-Received: by 2002:a1c:3a07:: with SMTP id h7mr6440243wma.41.1544618706332;
 Wed, 12 Dec 2018 04:45:06 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?0J7Qu9C10LMg0JLQu9Cw0YHQvtCy?= <allsys01@gmail.com>
Date:   Wed, 12 Dec 2018 15:44:39 +0300
Message-ID: <CAKKX_zOEE=N5FrTyfg6JzJ7FfrBix0dnoKK2tYvmTD2kwvEXrg@mail.gmail.com>
Subject: name hash mismatch
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello
If anyone could help with with "name hash mismatch" error at btrfs.
full error is
"BTRFS critical (device sda5): corrupt leaf: root=2234
block=244700761008 slot 136 ino=2531, name hash mismatch with key,
have 0x000000000026cd84d"
so i could not access one file neither to remove it.

uname -a
Linux linux-wwqj 4.12.14-lp150.12.16-default #1 SMP Tue Aug 14
17:51:27 UTC 2018 (28574e6) x86_64 x86_64 x86_64 GNU/Linux
btrfs --version
btrfs-progs v4.15

tnx in advance
