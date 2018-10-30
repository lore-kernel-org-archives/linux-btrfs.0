Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE63FC2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 15:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D5E20664
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 15:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pS4siCJN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0D5E20664
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbeJaALm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 20:11:42 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:45073 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbeJaALm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 20:11:42 -0400
Received: by mail-qt1-f174.google.com with SMTP id l9-v6so13845414qtj.12
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 08:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qqpCfcTbSUFN1BH9UqzBygd3jNkDiJYSRVbqlZdR8aI=;
        b=pS4siCJN3CErrMAFC3FyYulEK97b/8LsUBbme2af0tDurLz37PYABzdgGxhURKfV9U
         0mc4BP+TUbV3caCJ9OC88xcuvO0npXjdKFNb2fnoR6ac9gCQhi2dz+vxJUawlcdSFRnd
         FAtklCopp/qKWDZCa65/AbsBYDmWbxyT4hktS5xpBkVW8LwzazMYs2BlYkyqa6iSa3uG
         PXRG4Ge4knNiR0QpEdPygQxqMu0kEJX6mocgKy7q4glfiQigDyJeQBwQJ4EWazK3gN4W
         i7loj1ckGdTBFc7z0x/y8/Hm2cZNYpz3ftW6568VyHRba/DPJfe2z57r2enKQ4GSi4SI
         laJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qqpCfcTbSUFN1BH9UqzBygd3jNkDiJYSRVbqlZdR8aI=;
        b=CQCHf3pqKbK4aYZdx2CSfZ4xXlgmhnDoqT+R/UKS+7aZqzoUpuadUGFlGJVXbdQA3n
         QJG1Or174OL1aomVAqFhz1DCMe12jsUr5vxBN1FRR/8t2Fck5z0ntr4+zXXTpPFbBkM4
         Sq4dj81dekQGaccDP3hhd4EQUP3qiW12tJPwBDU8n4B0D+M8LZyVJKGHNkY3CrPBRlew
         GYK97Zy2TLo/xRRwXvANV1b5Ldm1scYho3Y/VB7Co5dCPh0CTEpJO5G2+8+8JHxMrzBX
         lcQxsxpU9WDlE70Fo9E0Y3irPayf8WS8ABzo4wfJ50GjoAvnKTNmTgrQjOcREwdqHkxK
         kk+w==
X-Gm-Message-State: AGRZ1gI0+SI/yM337LIA0h9gi9V6kCm/P5pGBSCpGzBmxPbq6/vSqB5B
        +Yzee9ZnXDTbPXn/5nI7ONiBEgswCC7jBrCRcfbd5w2T
X-Google-Smtp-Source: AJdET5c+geSuGZSXfhyL7rhS4j9LsAzafs+EPoUqTh8ujUmsvmZqHm4qXfn9v7YAz5MPqXgunFY05Z3eC1NVfjWgbMg=
X-Received: by 2002:ac8:1207:: with SMTP id x7-v6mr2589492qti.317.1540912668663;
 Tue, 30 Oct 2018 08:17:48 -0700 (PDT)
MIME-Version: 1.0
From:   Barbet Alain <alian123soleil@gmail.com>
Date:   Tue, 30 Oct 2018 16:17:35 +0100
Message-ID: <CAJzMQG2xPu7vy60qDjip+u93=3GU0v_ZXE9h8t_Tj1Vf6f5EnA@mail.gmail.com>
Subject: Where is my disk space ?
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,
I experienced disk out of space issue:
alian:~ # df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        7.8G     0  7.8G   0% /dev
tmpfs           7.8G   47M  7.8G   1% /dev/shm
tmpfs           7.8G   18M  7.8G   1% /run
tmpfs           7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/sda6        41G   35G  5.1G  88% /
/dev/sda6        41G   35G  5.1G  88% /var
/dev/sda6        41G   35G  5.1G  88% /root
/dev/sda6        41G   35G  5.1G  88% /srv
/dev/sda6        41G   35G  5.1G  88% /opt
/dev/sda6        41G   35G  5.1G  88% /boot/grub2/i386-pc
/dev/sda6        41G   35G  5.1G  88% /usr/local
/dev/sda6        41G   35G  5.1G  88% /tmp
/dev/sda6        41G   35G  5.1G  88% /boot/grub2/x86_64-efi
/dev/sda7       424G  200G  225G  48% /home


It say I use 35Go / 41. But I have only 5,8Go of data:
alian:~ # btrfs fi du -s /
     Total   Exclusive  Set shared  Filename
   5.84GiB     5.84GiB       0.00B  /
alian:/ # du -h --exclude ./home --max-depth=0
6.2G    .

alian:/ # btrfs fi df /
Data, single: total=35.00GiB, used=34.18GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=384.00MiB, used=216.75MiB
GlobalReserve, single: total=22.05MiB, used=0.00B

I try to run btrfs balance multiple time with various parameters but
it doesn't change anything nor trying btrf check in single user mode.

Where is my 30 Go missing ?

Thank you for any help
