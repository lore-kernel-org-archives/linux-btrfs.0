Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBD1C65C30
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 06:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC34C2088F
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 06:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HobW20NI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC34C2088F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbeJGNyQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 09:54:16 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:46752 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbeJGNyP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 09:54:15 -0400
Received: by mail-qt1-f173.google.com with SMTP id d8-v6so17958672qtk.13
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Oct 2018 23:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f1MCDfKbYaY6Y/wXTYJtLQ5utrinQNFQ19KugUYy8mI=;
        b=HobW20NIS0AYriZcNcKf7GdEzNTudF+9QlTVvxcCWs0dFz9lAGFgL3Ky1V3S3JBvN1
         MJdKN+esz2AKrMtk0JKmSpbPAzn3Mf747SkHtLT1rsiMCjGqtYcdtznC/yRjr16BfzFb
         P2J8Ujyna4W6+i/vuMFl67I91DY4fCH0QlPO0D4xOoPELoVZcj6BikXcAZeqVqX9zyIp
         4jZVbfrqcV5xa1mbQELFx2/xnKosLj3JqpWc0IA+su3bvVOnPsquj3pLV3S2htr9iMLs
         vUsfPFu+8ffZtZ2+3NBPQrgB1YW9dVsBjUw9vHglyQd2y0bPYOIGptwvTeMOBRc13DQq
         gJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f1MCDfKbYaY6Y/wXTYJtLQ5utrinQNFQ19KugUYy8mI=;
        b=r5PpC9X43/6Qph/hO6pv4TbD5mbnyhJZ7kWkex8Hyz7KN3RrySJC/QG08sFEUZDUTX
         Pszb2U1RXV8+hthyakclrhrLeg7m3cdMRnko2fHOJAkcdv2tWc/SGrWWhvj62Qszrslm
         vyU5tuPlCdNKAw3PRa4Iq7G0evHgW3xw3b6BW/hBmye5cUmlDM0QG14L078r3ngascnM
         Ev2S8kQsy2MT0IXxMFb1MHKTodGGx3K73wzxpa7mwrJ2FP6GDGTsSU3O0eivmqGk+4YH
         NQnMdJT33XNmVHm6QBBKCtpM63GJBQiyouQdE749IIrv50RMPHmpl8P0yX6x5AcChevb
         vFFw==
X-Gm-Message-State: ABuFfojol5EPXYeGiwsYVCcA516y7yx5zfF4N/yzdvdukYA6YEOHIj2G
        TADGWO+bDztg7RrRhqk1j6O4NheyRxNX682dbxE=
X-Google-Smtp-Source: ACcGV63jy+OsepfT3ixPJs6NQDDJDXGFJoSMJwLsQqjguM+svSexE4zyo6i/a+nJnUXrGfNfOCoh2yczByScHDQTHAM=
X-Received: by 2002:a0c:a8c3:: with SMTP id h3-v6mr4089455qvc.217.1538894878809;
 Sat, 06 Oct 2018 23:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
 <54132790-3f56-ef0f-d818-4f62f0b0a608@gmx.com> <CAG__1a4F12-jWG6q6k4NN_wrKr9GKh_p9bPV_Em+y6BCC-aYow@mail.gmail.com>
 <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
In-Reply-To: <64cd61fe-5e78-6201-f4b2-e88efba139bc@gmx.com>
From:   evan d <forumscollective@gmail.com>
Date:   Sun, 7 Oct 2018 08:47:47 +0200
Message-ID: <CAG__1a7Yc4eZ=YHsr8mZFCyu2ceW3CJDhgK0XDQK=wipVtQUxw@mail.gmail.com>
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS filesystem
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> None of your super blocks has correct magic.


I take it this applies to both drives?



> This means either your whole disk get corrupted, or something introduced
> some offset.
>
> Please try the following commands to dump more data around super blocks,
> so we could be able to find the possible offset:
>
> # dd if=/dev/sdb of=possible_sb_range.raw bs=1M count=128
> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" possible_sb_range.
>
> For a valid btrfs without any offset, the result should look like:
> 65600:_BHRfS_M
> 67108928:_BHRfS_M

# dd if=/dev/sdc of=possible_sb_range.sdc.raw bs=1M count=128
128+0 records in
128+0 records out
134217728 bytes (134 MB, 128 MiB) copied, 0.737479 s, 182 MB/s

# dd if=/dev/sdb of=possible_sb_range.sdb.raw bs=1M count=128
128+0 records in
128+0 records out
134217728 bytes (134 MB, 128 MiB) copied, 0.726327 s, 185 MB/s

# grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" possible_sb_range.sdb.raw
# grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D" possible_sb_range.sdc.raw

Both return nothing.

Both drives pass S.M.A.R.T. testing so I'd have to think the
corruption stems from some kind of offset rather than random
corruption.  They may have accidentally been inserted into a Windows
machine (but not partitioned or formatted).  Could this be a likely
cause?
