Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5E2C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C76D42063F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQFBqsuD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbfAHTdS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:33:18 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:37693 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731630AbfAHTdR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 14:33:17 -0500
Received: by mail-pl1-f174.google.com with SMTP id b5so2364461plr.4
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 11:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ugIpIwF8lWaxBkUQKtCzULJp5pOXVGpl7pp4ZqhCe2c=;
        b=MQFBqsuDUD5M5BRa24ERpnuORiSVzq8qo2sqWrqUlDdQ9n9VC6ks3+2IqiDUZ4Uwr0
         Fxa+mKt5GYtLb0YtP6ACEc/NssCTHL4wMQUmtGvZL+EBNOggX9mmOPR1nWnQItJJKJRv
         Mm8gahNoQ9hXBl/RT9TQ7Kfw2WdrTYljyRX5C7pI65aezIz9k3L8fDH4lnUqfM2ZCOnA
         XA+be3TjsjMV6cwWoZNcHqMPKo8rXptUihgCNZZsoZeTcSQuaRm6TnQ0hw3kAICsMvpE
         1gTbyXOHM9EF/oT0T6k0FGyBkNEhqdheqcXoJdyZ52arxPDFSCgsv45j/S3EYm68Tcaf
         D9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ugIpIwF8lWaxBkUQKtCzULJp5pOXVGpl7pp4ZqhCe2c=;
        b=V4L1AaDon/ictT649+AxCiJMQmG6tSpNbtsPuCYkh/FgUI1YRcZWiM7zN668yr1Mdo
         F0mKLuBVUjLBMs8Bhmr5c43G3fQ2mK94x1092+LOQlwx8C8l6/beHkfXqZmk10XolrMp
         h9J6PBhLJQIQKZJVZqb5kFpapfAL8vt9n9TWyp37yVoxaAn5V0skn/9VRYkNZdmhdixW
         FEsobS1LtawP3xjEhwxHCTP0Bt2aXV9HDwtfaOB7zYywasftEfpE/nns+gnpTmZEklwh
         dx0AljHf+82Z1UBih7Jl1vZxUCRjfU1qRDpnYUrFQ7vxpW0BBvX/HUagmJHf2MUrfkZl
         /NQA==
X-Gm-Message-State: AJcUukfXCodtvvLSACcaJ/in6Py/bspzWyaUNd17Cw++ESHzKwdsQDg1
        UGDJ66kcnRaSRj5iAEHUnHAMl7Afc6wW5Erxvf/WSg8w
X-Google-Smtp-Source: ALg8bN7hqa5iKXvv3vGmyNNLqhFbCCMC8ECHxb3hdajNcQQCSU66pcNSpLEpmELqb31J6gPDgURP7ZSwDA7e3WgS/qg=
X-Received: by 2002:a17:902:d01:: with SMTP id 1mr3076767plu.127.1546975996085;
 Tue, 08 Jan 2019 11:33:16 -0800 (PST)
MIME-Version: 1.0
From:   Thiago Ramon <thiagoramon@gmail.com>
Date:   Tue, 8 Jan 2019 17:33:19 -0200
Message-ID: <CAO1Y9wrAzSxGx+LYMPswzN4BbMNs__v7+y=BTZRBAW2bRN5Q1w@mail.gmail.com>
Subject: Nasty corruption on large array, ideas welcome
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have a pretty complicated setup here, so first a general description:
8 HDs: 4x5TB, 2x4TB, 2x8TB

Each disk is a LVM PV containing a BCACHE backing device, which then
contains the BTRFS disks. All the drives then were in writeback mode
on a SSD BCACHE cache partition (terrible setup, I know, but without
the caching the system was getting too slow to use).

I had all my data, metadata and system blocks on RAID1, but as I'm
running out of space, and the new kernels are getting better RAID5/6
support recently, I've finally decided to migrate to RAID6 and was
starting it off with the metadata.


It was running well (I was already expecting it to be slow, so no
problem there), but I had to spend some days away from the machine.
Due to an air conditioning failure, the room temperature went pretty
high and one of the disks decided to die (apparently only
temporarily). BCACHE couldn't write to the backing device anymore, so
it ejected all drives and let them cope with it by themselves. I've
caught the trouble some 12h later, still away, and shut down anything
accessing the disks until I could be physically there to handle the
issue.

After I got back and got the temperature down to acceptable levels,
I've checked the failed drive, which seems to be working well after
getting re-inserted, but it's of course out of date with the rest of
the drives. But apparently the rest got some corruption as well when
they got ejected from the cache, and I'm getting some errors I haven't
been able to handle.

I've gone through the steps here that helped me before when having
complicated crashes on this system, but this time it wasn't enough,
and I'll need some advice from people who know the BTRFS internals
better than me to get this back running. I have around 20TB of data in
the drives, so copying the data out is the last resort, as I'd prefer
to let most of it die than to buy a few disks to fit all of that.


Now on to the errors:

I've tried both with the "failed" drive in (which gives me additional
transid errors) and without it.

Trying to mount with it gives me:
[Jan 7 20:18] BTRFS info (device bcache0): enabling auto defrag
[ +0.000010] BTRFS info (device bcache0): disk space caching is enabled
[ +0.671411] BTRFS error (device bcache0): parent transid verify
failed on 77292724051968 wanted > 1499510 found 1499467
[ +0.005950] BTRFS critical (device bcache0): corrupt leaf: root=2
block=77292724051968 slot=2, bad key order, prev (39029522223104 168
212992) current (39029521915904 168 16384)
[ +0.000378] BTRFS error (device bcache0): failed to read block groups: -5
[ +0.022884] BTRFS error (device bcache0): open_ctree failed

Trying without the disk (and -o degraded) gives me:
[Jan 8 12:51] BTRFS info (device bcache1): enabling auto defrag
[ +0.000002] BTRFS info (device bcache1): allowing degraded mounts
[ +0.000002] BTRFS warning (device bcache1): 'recovery' is deprecated,
use 'usebackuproot' instead
[ +0.000000] BTRFS info (device bcache1): trying to use backup root at
mount time[ +0.000002] BTRFS info (device bcache1): disabling disk
space caching
[ +0.000001] BTRFS info (device bcache1): force clearing of disk cache
[ +0.001334] BTRFS warning (device bcache1): devid 2 uuid
27f87964-1b9a-466c-ac18-b47c0d2faa1c is missing
[ +1.049591] BTRFS critical (device bcache1): corrupt leaf: root=2
block=77291982323712 slot=0, unexpected item end, have 685883288
expect 3995
[ +0.000739] BTRFS error (device bcache1): failed to read block groups: -5
[ +0.017842] BTRFS error (device bcache1): open_ctree failed

btrfs check output (without drive):
warning, device 2 is missing
checksum verify failed on 77088164081664 found 715B4470 wanted 580444F6
checksum verify failed on 77088164081664 found 98775719 wanted FA63AD42
checksum verify failed on 77088164081664 found 98775719 wanted FA63AD42
bytenr mismatch, want=77088164081664, have=274663271295232
Couldn't read chunk tree
ERROR: cannot open file system

I've already tried super-recover, zero-log and chunk-recover without
any results, and check with --repair fails the same way as without.

So, any ideas? I'll be happy to run experiments and grab more logs if
anyone wants more details.


And thanks for any suggestions.
