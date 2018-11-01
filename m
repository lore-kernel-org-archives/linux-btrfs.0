Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B035EC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 20:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F0120657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 20:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LOhPuAmb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68F0120657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbeKBFpF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 01:45:05 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:38149 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbeKBFpE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 01:45:04 -0400
Received: by mail-lf1-f41.google.com with SMTP id p86so12962932lfg.5
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 13:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=d2/Pv5h6j4ASceDjSSb3K+U7encR/iX6D6MiVbK7hN8=;
        b=LOhPuAmb5L/qWc2nPb4Ma19DDrRH0+Vs1uHlr35bApSv8J1yaPPORPfTWOzd14zv0F
         JexzLoK0YZ3C7dhwH/VfAN4sH3+Pj2D2058xKqLflzm5NL3+S8X2Dy1oz5IKbRM+4Bp/
         VlVf9aOfoesq554iyq3NoNEZBI6pJnF0CCwjtJF+tap+zVCfloci2ZRj94JqV1d4k1v2
         YZFd2DVBxID6KQi5WCOsAYIobft1xqnct431L2a2GiyfSZC65HUpGhtTd5vbC4Lj8PVt
         pjSwcxC007yIKmrDfO0Ml8JXcR/Nlsy3s4ti6OduTFc8bdaku45qo1+u0c3gESBN43M/
         uxsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=d2/Pv5h6j4ASceDjSSb3K+U7encR/iX6D6MiVbK7hN8=;
        b=hdYWegWiJeJFNdHokWwiSEjFAcG1Fh/T1ovtWKkH3QGV5obdmNn5ebSDpHvHva0QRU
         6zsCr4QWMsvekwhKuSAkhfiYRXrebUKohbHJ5iwQSeNI2+ZXVorL3hBSbGWwy2p4mRUu
         o+gCPfgCCAniqFDN+zK2feGYGEAsiSjojUeJXdpx7d/T++M3jGvnKbQAmMpvH9UpURUq
         NjoA6+RzjcYkjPohLqSzRg2QxQ7x+/pconduDuxGB3Z8gY/mfstCsx90GsoUC+dYBOTI
         LRo0DCkhtQ3D7CUOnD7YgU9YjwmuO4nPOwnOMw62/QT4sh7qeIHumzonr/9s4XTp55DX
         wV9g==
X-Gm-Message-State: AGRZ1gKXNvbfOYGJ+xPB2nh7ZZlk9Xa8gjWnPTCu0KP6XFder0JhxFGa
        saJFKyfCSlClH84eUaLTLmA/KUbJ2X62A/ErDqgtKXAn
X-Google-Smtp-Source: AJdET5fzeRbfrXBCN2MXkwdrUfq0gyDUFowBLOCPwA2UGt+OSuSjNIA1sq6a1N56THqfaZurF12KVHNXNApoAx0JDrQ=
X-Received: by 2002:ac2:4159:: with SMTP id c25-v6mr5567232lfi.19.1541104829487;
 Thu, 01 Nov 2018 13:40:29 -0700 (PDT)
MIME-Version: 1.0
From:   Attila Vangel <vangel.attila@gmail.com>
Date:   Thu, 1 Nov 2018 21:40:17 +0100
Message-ID: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
Subject: btrfs partition is broken, cannot restore anything
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Somehow my btrfs partition got broken. I use Arch, so my kernel is
quite new (4.18.x).
I don't remember exactly the sequence of events. At some point it was
accessible in read-only, but unfortunately I did not take backup
immediately. dmesg log from that time:

[ 62.602388] BTRFS warning (device nvme0n1p2): block group
103923318784 has wrong amount of free space
[ 62.602390] BTRFS warning (device nvme0n1p2): failed to load free
space cache for block group 103923318784, rebuilding it now
[ 108.039188] BTRFS error (device nvme0n1p2): bad tree block start 0 18812026880
[ 108.039227] BTRFS: error (device nvme0n1p2) in
__btrfs_free_extent:7010: errno=-5 IO failure
[ 108.039241] BTRFS info (device nvme0n1p2): forced readonly
[ 108.039250] BTRFS: error (device nvme0n1p2) in
btrfs_run_delayed_refs:3076: errno=-5 IO failure

At the next reboot it failed to mount. Problem may have been that at
some point I booted to another distro with older kernel (4.15.x,
4.14.52) and unfortunately attempted some checks/repairs (?) e.g. from
gparted, and at that time I did not know it could be destructive.

Anyway, currently it fails to mount (even with ro and/or recovery),
btrfs check results in "checksum verify failed" and "bad tree block"
errors, btrfs restore resulted in "We have looped trying to restore
files in" errors for a dozen of paths then exit.

Is there some hope to save data from the filesystem, and if so, how?

BTW I checked some diagnostics commands regarding my SSD with the nvme
client and from that it seems there are no hardware problems.

Your help is highly appreciated.

Cheers,
Attila
