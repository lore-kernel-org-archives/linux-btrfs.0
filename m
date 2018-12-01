Return-Path: <SRS0=eQkg=OK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93EFC04EB9
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 23:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A04F2081D
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 23:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUk3WwIZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A04F2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725753AbeLBKex (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 05:34:53 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:55836 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725729AbeLBKex (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2018 05:34:53 -0500
Received: by mail-it1-f193.google.com with SMTP id o19so4016192itg.5
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Dec 2018 15:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:reply-to:mime-version:subject
         :message-id:date:to;
        bh=al94s7PCXjADt9iL5gzoTQ7WyDM+Q1lyzYHQ+5QzkYs=;
        b=NUk3WwIZX8w3nL5dIC6f47ig+LeajbSFlaa0MPo3of4MfJPSC0AXz6xa9uqf10Xkw5
         X1tfYWImLLYZoV+Kcq/l8WiC+aYhjelTeFV8npTDmXojbtX4k2hihhmwd4Nte2uUSaSO
         3DHq9mbEWdgsp/LR1TjWR5R5V9HD5ea2GByCFFC/CXtotMGcCTJ0M5svo+NxaxNE4cIZ
         wNRKoZZacaJIVnOBEju39UG1FaCopODwjcDOTEOcgnDzRufXn94a75XPIxi076pYZYK+
         A8qwQvAiibgLsJvUeFksXomjiSCowZG6Kv/PcCYFzXPY+pZK9rMg17JGToLH+DLNLEzm
         niCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:reply-to
         :mime-version:subject:message-id:date:to;
        bh=al94s7PCXjADt9iL5gzoTQ7WyDM+Q1lyzYHQ+5QzkYs=;
        b=UJYbP/tzHQbdN3Z3UMRBIqMrhLCwo982eWA6tMsTc96aC0r4xQXTiwfL+G/mX080ll
         AogDkqXhZ5yj6U1ni5eAyM2LohTnbi/66C4i9FDj8gJR0WRii1/zYFRj07DKuDlEvXqP
         KdV760OKjusEY2gLInIsgrbyAcxTJKTGxQNjcBtDL753yIQiOVSd7jS3OPYIb2yvkWJq
         IGaYxRSYyq2FXQNW+msn7Y5pw7f0g1TsjWdkdSOJNLq0NRUVttE6nu8ht7NLKBr/DVQI
         83h2uAoadTp41zrV4OHPwc1QwbES+AfWXVX5pYRXvTpG/+ghT94H3VQfSW/ksBZQTDN7
         G1wA==
X-Gm-Message-State: AA+aEWYsKGg+385JyHGyHEjKfO7z9MY8yE6U/+slXMGFd7ZasqrmdzAe
        7HG+YC3jxQvo/D5xkkaqS5A=
X-Google-Smtp-Source: AFSGD/Vs5fzSkURP8p2zzkqg4ngfRKSbprZFb5Q7tjASFf0DCI9ztaMlspemNuDrrTqlmPNzShW//g==
X-Received: by 2002:a24:7a94:: with SMTP id a142mr2915991itc.88.1543706474641;
        Sat, 01 Dec 2018 15:21:14 -0800 (PST)
Received: from [10.0.0.233] ([8.42.79.29])
        by smtp.gmail.com with ESMTPSA id u22sm3529523ioc.28.2018.12.01.15.21.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Dec 2018 15:21:14 -0800 (PST)
From:   Martin Bakiev <mbakiev@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Reply-To: CANznX5GqHJwx+y6b9kruzYXEP93oEhRtHyG_yuWwHV286+fQdw@mail.gmail.com
Mime-Version: 1.0 (Mac OS X Mail 12.1 \(3445.101.1\))
Subject: Re: Possible deadlock when writing
Message-Id: <ABEF1951-66FC-48F8-A7C4-0D499F48AF84@gmail.com>
Date:   Sat, 1 Dec 2018 16:21:13 -0700
To:     toth.f.janos@gmail.com, llowrey@nuclearwinter.com,
        linux-btrfs@vger.kernel.org
X-Mailer: Apple Mail (2.3445.101.1)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I was having the same issue with kernels 4.19.2 and 4.19.4. I don=E2=80=99=
t appear to have the issue with 4.20.0-0.rc1 on Fedora Server 29.

The issue is very easy to reproduce on my setup, not sure how much of it =
is actually relevant, but here it is:

- 3 drive RAID5 created
- Some data moved to it
- Expanded to 7 drives
- No balancing

The issue is easily reproduced (within 30 mins) by starting multiple =
transfers to the volume (several TB in the form of many 30GB+ files). =
Multiple concurrent =E2=80=98rsync=E2=80=99 transfers seems to take a =
bit longer to trigger the issue, but multiple =E2=80=98cp=E2=80=99 =
commands will do it much quicker (again not sure if relevant).

I have not seen the issue occur with a single =E2=80=98rsync=E2=80=99 or =
=E2=80=98cp=E2=80=99 transfer, but I haven=E2=80=99t left one running =
alone for too long (copying the data from multiple drives, so there is a =
lot to be gained from parallelizing the transfers).

I=E2=80=99m not sure what state the FS is left in after Magic SysRq =
reboot after it deadlocks, but seemingly it=E2=80=99s fine. No problems =
mounting and =E2=80=98btrfs check=E2=80=99 passes OK. I=E2=80=99m sure =
some of the data doesn=E2=80=99t get flushed, but it=E2=80=99s no =
problem for my use case.

I=E2=80=99ve been running nonstop concurrent transfers with kernel =
4.20.0-0.rc1 for 24hr nonstop and I haven=E2=80=99t experienced the =
issue.

Hope this helps.=
