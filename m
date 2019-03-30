Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F032C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 10:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7090205F4
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 10:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeWrW259"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbfC3K0Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 06:26:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46416 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730471AbfC3K0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 06:26:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id t17so5560858wrw.13
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Mar 2019 03:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Gl8ib3KTQ0KqEhGrVrhYpQKfWvKA5HeXqg9uLr2drPc=;
        b=jeWrW259Y53CkF4oS5Qw+RDTdTw/ItQqETqCCsLZ+D7BMslMltY/LeSJqMAevg4Und
         y4XYZezie+X/NoVEwzTmFvCLsncFMzQQLPTKX/qkCNhgyb0/Nl5blLs9wKhF0BABYRa0
         vf71nzHg550BnE2BBYTFHbU4iqrgJubcsWQ6XMacV8ugFX7rye4NQp8ikixfLETI66Tc
         kAhpXExyEWTOj3n2f0nE/XvvaYDssP12ot1KVJt+JpPimZrf8L4TCxEV5uTv/+38YSGK
         OcnG1m57fUeirC8+4YWQQhRzOQoB/sIMBLnNu+FOqt2PNB8opcbIjxaQD6wH+V37nIeW
         jBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Gl8ib3KTQ0KqEhGrVrhYpQKfWvKA5HeXqg9uLr2drPc=;
        b=feyYsKGpsdmcO2eMlJWG3LFt0DejMRzDUNcDNlCriJjk/NqNCL18Tkqja/xSPn3msD
         o+NmgOWg2bjwADhCsr2cdPmytjQbRWodQNwXummVjTrSYNvh5NfN8JLkeERXII9Dc8/4
         e5iXuJeBlFyLYYXffSNb0GB/TPxVuM8/p+z5FW3QOZhugza6ljM5oj5ksXshN4FDwGQL
         Od8t7ybawk5YMAWPSB7j2XQVTo8nU/gVCmXR19CmQj1cYwV6CRUZgF0qAFYX4TQgKQ1s
         MQUDJjx2KUvWzje0Mg+TZ3QldBOguVbK6z23gSFQitKUOmUJaFHwk7B1ISufu9w0RPI1
         WlLg==
X-Gm-Message-State: APjAAAWjnx9lEvWiW+KuV2UgF47bmAwawroiHSKL9nLOiWMguyj9Krc0
        6LBNNStmqNVSDMqk2A3AP8zuclP48JK+xW8Le3V6IHxw
X-Google-Smtp-Source: APXvYqyyjN7tge4dGd2C8La0mgsEvbi9oj2rpxIcVuzHY0MPso5RuFr82zrRbarcowlYhUMPu+QLVZ7DX85NkGs7cCQ=
X-Received: by 2002:adf:eed1:: with SMTP id a17mr1732904wrp.268.1553941573681;
 Sat, 30 Mar 2019 03:26:13 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Date:   Sat, 30 Mar 2019 11:26:02 +0100
Message-ID: <CAOsCCbMp=Jy6jeZi_eSK_u77ScAaMC1-KWErxU9T=E3qMWQv0A@mail.gmail.com>
Subject: Unrecoverable Btrfs filesystem after a single power failure?
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi!

I have a strange case of a Btrfs failure.

I'm running Manjaro, btrfs-progs 4.20

# uname -a
Linux unfa-desktop 4.19.30-1-MANJARO #1 SMP PREEMPT Tue Mar 19
17:49:12 UTC 2019 x86_64 GNU/Linux

I've been writing data with rsync to a 3 TB Wester-Digital MyBook via
USB 3.0, when accidentally, I've cut power to the disk's power brick.

The result - I can't do anything with the filesystem any more.
Whatever I try I get this:

# btrfs check --repair --init-csum-tree /dev/sdc
enabling repair mode
Creating a new CRC tree
Opening filesystem to check...
parent transid verify failed on 1634923266048 wanted 1530 found 1532
parent transid verify failed on 1634923266048 wanted 1530 found 1532
Ignoring transid failure
Couldn't setup extent tree
Couldn't setup device tree
ERROR: cannot open file system

This is a backup drive, and I don't need it to recover, but I want to
learn from this as much as possible. Power failures happen, and I want
to know what to do when the same thing happens to my main production
filesystem.

You can read more detail here:
https://unix.stackexchange.com/questions/509565/unrecoverable-btrfs-filesys=
tem-after-a-power-failure

And much more detail here:
https://forum.manjaro.org/t/unfixable-btrfs-filesystem-after-a-power-failur=
e/80994

I am writing here as I'm completely out of ideas at this point, and it
seems like this is a very rare case.

I was very happy to switch to Btrfs from ZFS, but now I am not so
comfortable using it, if a single power failure can completely trash a
filesystem beyond all repair.

Or can it?

--=20
- Tobiasz 'unfa' Karo=C5=84

www.youtube.com/unfa000
