Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7935EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 00:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 406E72184E
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 00:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/EDSec4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfBRAHX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Feb 2019 19:07:23 -0500
Received: from mail-yb1-f176.google.com ([209.85.219.176]:41331 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfBRAHX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Feb 2019 19:07:23 -0500
Received: by mail-yb1-f176.google.com with SMTP id 18so4485998ybf.8
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Feb 2019 16:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=8RciC6vgF3KwZrNGGIyhEg+26xc6ShuZT1tGqHW3Q1M=;
        b=g/EDSec4+jvkH4/17RLnQLnVb9K0uaSAy9An3PEt/ERH5lRS4gI+cmixyXPx9zuDyT
         AUzUgBcf1Z7A42o6RqBE4dDwKYet+PNSDxDaQJaIPzdgX5/K18ERcsxH/Vtf9XHPVBXu
         zLchMBvm7x6OJS3tZHkLh5ttfgBtb3S8WkUKy8p51Ms6Eipyc9g4HtV3ijhrzB0g04J5
         6/VkADv9OuFoXNCYiToD9B3SeSXMnbdnnW2TYF7Rk+Pqu+uPbupBN5v2yOhgCjU7Ufbt
         NOny3XR5yXNfpX3xlWOIcPZj4rKTdJHrO255EfoHE4KNqoG3pcKeEcA+5KPmV7FrMIOQ
         HQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=8RciC6vgF3KwZrNGGIyhEg+26xc6ShuZT1tGqHW3Q1M=;
        b=U2d3dAN+6L1MMexZ2kaYN/2GmZ4uYK2QHVdRRDM9mac0zZAbIaFsULD7W4wmJeOk4R
         qU8vUS8iEMlvrglH9un9iU2h8kG0gXfQh9CiUaRFOIivQMC/PmscRH5KgVWLFqgKCciM
         BoJOP9Bt8ZiQYdt6XP1qI83Ut84QKmAQJJXYlWvw0K9lWnNRBaEwK2sPgKRZsxgVY1Sn
         UdAlQL19Ai5xjkgReFhvPHnqnFL9GzdcuC/ZLcmvE/XZna4OixX/Wbc2MxUlUrN6EYUx
         U1oCFTyg2kE59H3TswcPgs+gbi3MXQh2A6cw5/gjl+jW07fDrhB9h22SNJvLp7+Z4+Cf
         8vaA==
X-Gm-Message-State: AHQUAuZadjBecWCBhxUZA65llURjwApB3dj3uY/CB3SXGuJ9EIlYeYCn
        AWwhoLu5PBhWpY34kGUEqhtrqFl6
X-Google-Smtp-Source: AHgI3IZfFWdzhkl4pev+gCu+OWEN1HM3w9BpjLts91oCWxQPtt+PzM4/pwQmWdnVP/M3Ssc4rQwsKw==
X-Received: by 2002:a25:b06:: with SMTP id 6mr17234980ybl.355.1550448441974;
        Sun, 17 Feb 2019 16:07:21 -0800 (PST)
Received: from CarlosLaptop ([149.149.2.213])
        by smtp.gmail.com with ESMTPSA id c68sm4806828ywd.52.2019.02.17.16.07.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 16:07:21 -0800 (PST)
From:   "Carlos Medrano" <crlsmedrano99@gmail.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: Subvolume ID 5 Showing Deleted
Date:   Sun, 17 Feb 2019 16:07:18 -0800
Message-ID: <020801d4c71d$eb30cd10$c1926730$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdTHGr2a6oIPNZbbRYiQIYJi0NjJrQ==
Content-Language: en-us
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Greetings Mailing List,

Is it normal for btrfs subvolume list -d to show id 5 as deleted? E.g.

[crlsmdrn@server001 ~]$ sudo btrfs subvol list -d /
ID 5 gen 707098 top level 0 path DELETED 
[crlsmdrn@server001 ~]$

Some background information:

This is a home server running 2 10 tb disks in a btrfs RAID 1 configuration
that is used for backups/file storage. A few weeks ago, I deleted a lot of
snapshots. While they were deleting, I disabled quotas because they were
taking a while to delete (btrfs-cleaner was running in the background with
96% CPU usage). Even after disabling quotas, btrfs-cleaner was still running
in the background.

Yesterday, a storm nocked out a powerline in my neighborhood, causing the
computer to reboot. When booting back up, I started a scrub operation, and
it completed with no errors. When checking the deleted subvolumes list, the
only 1 there was id 5.

If ID 5 is the root, why would it show deleted?
Uname -a shows Linux server001.carlos1001.com 4.19.9-1.el7.elrepo.x86_64 #1
SMP Thu Dec 13 10:52:03 EST 2018 x86_64 x86_64 x86_64 GNU/Linux

Let me know if I should provide more information.

Thanks,

Carlos

