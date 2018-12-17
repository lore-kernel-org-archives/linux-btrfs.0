Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724D8C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 18:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41B0420675
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 18:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtqcW2gV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389051AbeLQSfY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 13:35:24 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:43036 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387922AbeLQSfY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 13:35:24 -0500
Received: by mail-oi1-f178.google.com with SMTP id u18so10998920oie.10
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 10:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BI3qpv7VYialOe9nezqXrAj4GUxFKGoGfx7LgsrCvRI=;
        b=QtqcW2gV0gEIiAqT40fcgOvZJoENLFvmQ4Kre0Oio28cvz2QJHbCyIQjbHjNOapOQY
         1VNA1lwx8gECZBhCtzDjmsqAUzrFA6q5rhbPXe0P0YF6bB/nWKQHKQ00cKteLk8lUHwA
         lyBFcSKnxlsl9llKOYBIiZqueCBE4ZeD68njCJek0HDs5XHmWHsnXNDpQbn1GdmJuphF
         womGCTGUIqtFUY5TzgGo32Xdh2EHz2niQEhD6A4orsUI8PXd5BRtFQBtpCNRV5bTKspl
         CtzZYwij2tVlIRNg+vzeb0KIgmc+duPGnX+JC+gMDd8T1yQ1EAqnctOrriKdwhqOiVM8
         nEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BI3qpv7VYialOe9nezqXrAj4GUxFKGoGfx7LgsrCvRI=;
        b=gzZkvMEvxi38C3MpqrlXGgQQGxJF2D5AFqIdJA2tYFadiWUs62JAZvYNlq1fcGjOIk
         rDx5QYCnN1q7EG8uBgWeO91RJviqM9dJrfS/OrLcOo+eEwHyFXicl3zevRS2InZsQvRs
         X3XiJlTE7IyQjUk1EgzKy4ueL3PjgqtAJkXGVpAfrBSJCtTU0rV3WMPUhI8zwlbBd03z
         hSBzDIuYSme1CNFRYrJ3R/taHdXlkfw9aCDtEGL4Et8rpwQYhJD70eUDMfPJgmSD0Gqe
         YheaURm/cFm94MqvqFvnACgIiYj2InE0+DFEx2n80lR0MnjzcSbzk7T8j2fgrgJhpQD/
         Bf1g==
X-Gm-Message-State: AA+aEWZXfl/9uo0m9kHuu+6D7xAa8GR+CVLkPecgjgnKqwl8lI+JrWRX
        FwJQs0hZ7j0PaPMqDb7RlXP9IED2AU/4kKgo27QEZldvQxE=
X-Google-Smtp-Source: AFSGD/VBlhrDB6aSEyCwfvTALIYPPFoR0sA4VBWFv5SulofjNHJ7h/0Zmbxholh8FkcNo2fO4l7HwQjUVN4sQYOVH/s=
X-Received: by 2002:aca:b882:: with SMTP id i124mr6258781oif.127.1545071722779;
 Mon, 17 Dec 2018 10:35:22 -0800 (PST)
MIME-Version: 1.0
From:   Mike Javorski <mike.javorski@gmail.com>
Date:   Mon, 17 Dec 2018 10:35:10 -0800
Message-ID: <CAOv1SKBiuBvczaHxO67v6wUW=kJFtvLNkSPbPC99Zc24Wi+2Fg@mail.gmail.com>
Subject: 4+ hour hung task running btrfs receive - btrfs_delayed_meta_helper
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Greetings..

I was running btrfs receive to apply snapshots from another machine
and the receiving machine locked up with only a few KB received
(tracked with pv). I left it for ~ 4 hours with no change, and tried
to abort the receive and it would not exit. I then tried to "ls -al"
on the snapshot directory and that froze as well.

I then triggered a sysrq w, and have pastebined the latter section of
the output:  https://pastebin.com/fQFWq307
(I included everything after boot, there was no abnormal bits in the
boot and I didn't want to have to filter everything for PII)

Now it is ~16 hours later and both the "btrfs receive" and "ls"
processes are still locked in "D" state, but I don't know if I should
just reboot the machine (preferably not with a hard reset) or not. I
do have a keyboard attached so I can possibly do a SysRq forced
unmount if provided with "safe" instruction as I have never done that
before. I do find that I can list files in other snapshot subvolumes,
so the base FS isn't completely blocked, but is around this new
snapshot.

Other (possibly pertinent) info:
- Both machines are running the latest ArchLinux provided kernel of
4.19.8-arch1 and btrfs-progs 4.19-1
- The receiving machine had just replaced a failing disk with a new
one (via btrfs disk replace) and all indications were that it
completed successfully, correcting errors reading from the old disk as
they were encountered.
- I had also just deleted two snapshots which were of suspect
completeness and was re-sending one of those.

So that is the scenario. Happy to get more logs if needed, but would
welcome advice on how to proceed.

Thanks,

- mike
