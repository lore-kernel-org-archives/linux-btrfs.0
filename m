Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD34EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 14:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A222146E
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 14:42:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I88lanKT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfBSOmc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:42:32 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40268 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfBSOmc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 09:42:32 -0500
Received: by mail-lf1-f65.google.com with SMTP id t14so15098823lfk.7
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2019 06:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=p1BSc/NpOuQkZ98iq52yblA924DH3zxFYKRHgeKXGFc=;
        b=I88lanKT26CM5EczmBgjLCbUOAZ7Bl3EzonniWltehm1Zb4j9DusOsDMOJeFT0g0in
         zjUYAxZ57H8rIEiGymjDVYTwKYu8oSYtA3EpKbFrjdhfGSQE3RO6f3XYHShkq4PGwP1Z
         lgWU9FLOtQOCPfwe+FcPUNlMwU3mDJLfCxrr0LpZJGlo2hDUB6HlixrX3Kcjh82Abbwp
         qji8n3PGryL5IGKZRZ9xKc4PmRkxqWSSMjkDj95ucMfCv45XE8ot5iJlNwrP2nt91hb0
         q84eKtiUXw5sKIqm5qSAYZ8ohm6s96tK4/ZSpD93Umsb1hufeM1yihzZCbdKCdQLR2mw
         G2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=p1BSc/NpOuQkZ98iq52yblA924DH3zxFYKRHgeKXGFc=;
        b=tXxcGlUzP7veauE4Xa4JUzsBQZ4SpeXYWNPXBZSlYTStHZPZd7Ky7AiIcCt6lfC1nZ
         31taALHSTBUxcAtBCicLV+O9H4KRI4HhBvUO8M5y1LbhcoXgGTaXJSqXTr0eDpp5P/Fn
         GBxe9KakoDLq5REy1oJQUPvl0L2bLXwOuaM/PM8Q5RREEWpcjIbP1ucLMgsTvEV1TMtn
         Sg4tOrYh58z9sWdlVQ9+QQgoO4EPqXW3nyBLvzF1P5Ks3w+t6MlR+sRJpb2AbiUart0x
         B+a+ThUH9Ls9RbVAcXYV8h/e7hpFMv70MGY5nciN8Ng96V7oW/FYckhbpLDWbFET1B0a
         OTwQ==
X-Gm-Message-State: AHQUAuaPaAogwJFPT/8jErGHwHY7HLkKTODuOItQXdXJa4AhSg1mpA6A
        sF1QmlDkdcyXzlwT7TcadWOuqNdajZu8P81jn9ZA4DWF
X-Google-Smtp-Source: AHgI3IZU5qfjSOzZBa7fSXAc3/n77mzF8ChCnmJMRwpwNwUk+ClGrO/5Busle9ky7AkMb7zvZ7/Hn+wfUPUclzHUTfE=
X-Received: by 2002:ac2:4215:: with SMTP id y21mr18898652lfh.6.1550587349795;
 Tue, 19 Feb 2019 06:42:29 -0800 (PST)
MIME-Version: 1.0
From:   pkoroau pkoroau <pkoroau@gmail.com>
Date:   Tue, 19 Feb 2019 14:42:18 +0000
Message-ID: <CAMNwjELPWTLDFi=2Eyq0DZqW3Q+sqviz_R7CSp6cCV3QTJukPQ@mail.gmail.com>
Subject: Spurious warning fix backport for 4.9
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi, I use Debian's default kernel 4.9. I booted 4.14 temporarily, installed
system updates with compress=zlib:9, booted 4.9. Now, syslog is cluttered with
hundreds of lines like:

BTRFS warning (device sda2): unhandled fiemap cache detected: offset=0
phys=653004800 len=4096 flags=0x2000

The warning is apparently harmless, as noted at:
https://www.spinics.net/lists/linux-btrfs/msg68326.html

The line of code issuing the warning was removed upstream at:
https://patchwork.kernel.org/patch/9803291/

Is this the right place to ask for a backport to 4.9? As I understand the
release process, Debian would pick it with the next stable kernel update.

Thanks
