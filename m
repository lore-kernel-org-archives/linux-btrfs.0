Return-Path: <SRS0=qsaG=XE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF83C00307
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Sep 2019 08:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D415E218DE
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Sep 2019 08:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=constantinescu-eu.20150623.gappssmtp.com header.i=@constantinescu-eu.20150623.gappssmtp.com header.b="sbk76K84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfIIIW3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 04:22:29 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:34849 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfIIIW3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2019 04:22:29 -0400
Received: by mail-io1-f48.google.com with SMTP id f4so25979865ion.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Sep 2019 01:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=constantinescu-eu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=TaQUe1uKTL7eSgRtUhFVV1GBJ6s6+ZAfjU5ORA+p20c=;
        b=sbk76K84aIRo+o8GK1m/89zNNdtagla0Ne+rWpQqJZINM3PHlH/ZdAPA+Rr2XBrL+1
         GYeabG1UncXG+IwLUzBKXRJI6p3IzV/vw15zZI6jmctg50dIGjhHXaP8RzqXUkwORxGG
         92ZfM+SgWTMHrIDlQmOsHXfld3m8GB7wi2Ees5JtV/+9d7t+m8xHd9rn+kSriiC0G72+
         5IOsMl69NQR/s/rcM8tJRmWUHBIyb+OhkG1uebo6nHGoJma2RYjz30UOebjvYuK7Cec8
         sLr2hr5lXVJNyNYwnY+nDKPed3cxDnPFLavhpDhm+sWMsCY7DBbxhE0kFFs8t4Vfiz35
         8YeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TaQUe1uKTL7eSgRtUhFVV1GBJ6s6+ZAfjU5ORA+p20c=;
        b=lm9325jNNke5SrzsFkas5cdQ1Rt/DkPT3kLM1sJyxWJizu3DTJg9sYbBAvOxDZ1SSC
         G4ByrbejjN9kaSJIkWnf9YK5sM61tamiuTFS33bdFtBi9DTsXfmnSKlTP/OdiWaJQ7du
         yHYjNYzbXIgqeMbo9LO5490RaD9iTb7e9r0lQmjU2TH95h2K/yflYNguLolQDUgjX1A+
         tLmWR5zA6uKmPgBjnjqsALOvR199JmFRnYDNvRQn1t/lqTD2g7H8g56KBDPGpYmV83WZ
         vjvfjAiwpX0RHtWequgWMLr0oP9I6+MEM/0M4dvXnruu56osj9bqvxOpetMz5kWR2Y7D
         Bw0w==
X-Gm-Message-State: APjAAAXOMZG2dq0VIi8RFhu9xQAp2GDukxTTobv/tqsAau+kJD9YP/M3
        sRXVk2aZi3VYJWgoa0BE1cVV8WCG6jl67xdKOYstXdYrbzMoLA==
X-Google-Smtp-Source: APXvYqzC+Xbld21RIPYozHZQrr+zgjOqHuOQWJ0DfDmkI5ysMNRlfMsvz8RmjlY+Iy2enNwrY3BqvnmYNzUkHS3MZ7M=
X-Received: by 2002:a02:5dca:: with SMTP id w193mr11641187jaa.94.1568017345642;
 Mon, 09 Sep 2019 01:22:25 -0700 (PDT)
MIME-Version: 1.0
From:   Alexandru-Iulian Constantinescu <iulian@constantinescu.eu>
Date:   Mon, 9 Sep 2019 11:21:48 +0300
Message-ID: <CA+y2nj-M31yEVrW4cFkSsEDQBGD5ub5Wfm6M-8rB-KgVgko=VQ@mail.gmail.com>
Subject: Direct IO and CRCs gotchas
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The issue is described here
https://forum.proxmox.com/threads/how-to-setup-kernel-stable-pages-parameter.57403/
( including rationale for not posting full content here).

Thanks!
