Return-Path: <SRS0=vb8r=PN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769FDC43387
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 12:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 308C32070D
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 12:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVCvjop8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfAEMbi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 5 Jan 2019 07:31:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40701 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfAEMbh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2019 07:31:37 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so38806423wrt.7
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Jan 2019 04:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KStxCLGCmIXg5Rp5qYzLB5mt5nTbDZUdfhEsCVUIQgE=;
        b=LVCvjop8Pwv8bTSnM2CXCN547UpaDknDZ+t0WA/MsX+aGuV628gZOPUXeNN5btD6Rx
         nIE9weUbv0/FxxUaOqVdx+AiN7NKQ20rannHiZAWpZHDgwRCLeXxxsJm4WsUO6/tczbJ
         Qic7jKmH32hMHU6jMOtR9W//xZDLVEdTw727JigvnkPPXo5U+RkCL0zkTg7adMJXbABB
         cEOiZOjY/rb+NKdMIT0fMig8xwCzga5KJ565Y13EAw7IySIiUZIhNh+qK3fVsxzFzwAr
         9o3b0MWcRDTcnhRk2ejiKwFZUY+DNLmBu7tH5KPc/2FgWcY7Tldxz5fM8rcWscOprRNn
         eUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KStxCLGCmIXg5Rp5qYzLB5mt5nTbDZUdfhEsCVUIQgE=;
        b=SEA75OhJRsPCa0vDv7O2BMldOfytcYM8fWZNuE8EsZzcqVo5uV4sf8GbdyQotbE1OC
         FUrmqnTx9MgXjw3zktcSc1xoDF+YJI6MOxEL3ZCxO5Yrim0yvRi/Ds0RQCbRSSv1wOnV
         zF1Rlc8PsM1HQcIZJ/NU7cPi/K30OxkOs8RiCYUiVTm+y5uypzOU3DXrPabPRDr9h0Wn
         BWHU+Ay43sa2amCTkeuXWSdxzbtmTpo78YZtJbC0S4S1S3BpV3NUfKZnENsLvGbnyJS3
         jV8wTNPy1jIvLEfRptZUGJTfvAyInkBcwhBomNdgizseS1JoawGY4KDJtoK/nB4+3Muh
         eLWQ==
X-Gm-Message-State: AJcUukfjciBGxSQCDqbhVnw01MdS5kxO/Eog3eTMTVGLnhBGDkjDu18t
        QsphDVwmd0Jha/pPHQH+1JUfqxqj
X-Google-Smtp-Source: ALg8bN7moDe4cVqUrGooMz4bx7+02wkN74qcXhrGr1WmsRw0YDUmVUrXemNRjt6/hdy0rHpX8myg5A==
X-Received: by 2002:adf:ec83:: with SMTP id z3mr47522030wrn.264.1546691495602;
        Sat, 05 Jan 2019 04:31:35 -0800 (PST)
Received: from exnet.gdb.it ([5.90.3.93])
        by smtp.gmail.com with ESMTPSA id e16sm54208103wrn.72.2019.01.05.04.31.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 05 Jan 2019 04:31:34 -0800 (PST)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     Jeff Mahoney <jeffm@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
Date:   Sat, 05 Jan 2019 13:30:50 +0100
Message-ID: <2971657.kkKnYu9ILp@exnet.gdb.it>
In-Reply-To: <067ee226-4636-4ede-1ce7-2bedcc5b4507@suse.com>
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <2282965.574ZSNQ4d8@exnet.gdb.it> <067ee226-4636-4ede-1ce7-2bedcc5b4507@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In data venerd=EC 4 gennaio 2019 21:34:03 CET, Jeff Mahoney ha scritto:
]zac[
> >=20
> > root     17133 17127  0 17:17 ?        00:00:00 btrfs subvolume sync -s=
 2
> > /
> > tmp/tmp.p9SiQ1GnpV
> >=20
> > cat /proc/17133/stack
> > [<0>] hrtimer_nanosleep+0xce/0x1e0
> > [<0>] __x64_sys_nanosleep+0x77/0xa0
> > [<0>] do_syscall_64+0x5b/0x160
> > [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [<0>] 0xffffffffffffffff
>=20
> Ok, so this is it just sleeping between tree searches.
]zac[
> This part is actually important since we see below that we're searching
> for bytenr 76428623872 which, if present, would be in the cut portion of
> your log.
]zac[

If you want, I can send you the full log (very long).
=46rom what you wrote below it seems to me that you do not need it

]zac]
>=20
> This is the more important part.  The file system has gone read-only due
> to a missing extent backref.  This is corruption.

Yes, but this is an autocorruption of btrfs, which occurred (it seems to me=
),=20
during a cleanup after a deleting of a snapshoot of an operating system=20
installation (perhaps interrupted by an umount).

> It also means that the subvolume is never going to disappear during this
> mount and 'btrfs subvol sync' will wait forever.
]zac[

In my opinion this is bad.

The infinite wait occurs during the execution of a backup script, so I will=
=20
have to find a bypass even for this problem (the sync was a patch to anothe=
r=20
autocorruption problem).

Gdb


