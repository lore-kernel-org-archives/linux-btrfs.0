Return-Path: <SRS0=3O7H=PG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C57C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Dec 2018 22:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B3CD20873
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Dec 2018 22:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbeL2WXZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 17:23:25 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:38551 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbeL2WXZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 17:23:25 -0500
Received: by mail-lf1-f42.google.com with SMTP id p86so16522812lfg.5
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2018 14:23:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=TMRDqoEd2CDkkun/tJSgToO2x6+cJqp1RmOO4GyY/rU=;
        b=b66F7f/EQW6jZ/SGoUvhlUEC1PHxzCEqVWyN+4JIViVzVNYfkY1ECjFDhG8dfH5Yv/
         TU9JjgVzflCgWcZ2j6+FGxYccmRXl4TJ4YJgkUfttYi/IHh8NaiBt0njTmU4gHYk0m9c
         ynS03I6492FTb+D4gLyQ+dcjdn7w72Aj/UpS/mcGeGSimyjk5xtkcGoUX0z3mFeqjZOh
         gnoLFr5GG4J5GKOmKcuLlW3wKSo+xebSDvPTGhnM9WyGg6LvtyZEnLul7YOPBu4k2qWU
         VEqMxupBgjvNXqBQaG+urE0uCILXgyLmFaiIR4gJRqifcZxdxhbcZfkOiMJhpitN36RS
         Nttw==
X-Gm-Message-State: AA+aEWadxfLqBAsFwIe4oYGwrKbPuvWLEZWMuWzBlTiGNrXBuirN14pT
        LwADDsswfEcuTTJ507+ex81pPjTgYc67r7hXb5GNOazc
X-Google-Smtp-Source: AFSGD/XpCXpY1IgSccYQCmsM1uEq+PQAzMPAKUcRCDx33C5+y0mIh93uYEBZxTeDYN0zzPqsB5vjB74oLAz259+I2Is=
X-Received: by 2002:a19:2584:: with SMTP id l126mr15677985lfl.69.1546122202792;
 Sat, 29 Dec 2018 14:23:22 -0800 (PST)
MIME-Version: 1.0
From:   Adrian Bastholm <adrian@javaguru.org>
Date:   Sat, 29 Dec 2018 23:22:46 +0100
Message-ID: <CAMrg+aRiTuesnBYx=UxQBXLSDXXwFOAKuFtGcwB6ZebQgycCXQ@mail.gmail.com>
Subject: Undelete files
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello all,
Is it possible to undelete files on BTRFS ? I just deleted a bunch of
folders and would like to restore them if possible.

I found this script
https://gist.github.com/Changaco/45f8d171027ea2655d74 but it's not
finding stuff ..

./btrfs-undelete /dev/sde1 ./foto /home/storage/BTRFS_RESTORE/
Searching roots...
Trying root 389562368... (1/70)
...
Trying root 37339136... (69/70)
Trying root 30408704... (70/70)
Didn't find './foto'

-- 
Vänliga hälsningar / Kind regards,
Adrian Bastholm

``I would change the world, but they won't give me the sourcecode``
