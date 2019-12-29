Return-Path: <SRS0=hNl+=2T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4262C2D0C0
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 Dec 2019 20:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EC98207E0
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 Dec 2019 20:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfL2UoK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 29 Dec 2019 15:44:10 -0500
Received: from mail-ot1-f51.google.com ([209.85.210.51]:44362 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfL2UoK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Dec 2019 15:44:10 -0500
Received: by mail-ot1-f51.google.com with SMTP id h9so41139794otj.11
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2019 12:44:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5GT41iMT76DnZIv+Qs6EYjJ2+Vm840IPI2yrjlohiLI=;
        b=NNxz7lpMRXKUQfhlm4YXH0fxar/ZuKX9mXDFxFlDVt+W/k/76l4UkfSBBAgP2ozFPD
         ZtrjOO0DmhvW6hPWwEbUxgORko0QcJzH2gQXws4cbToCYOypFsBnYj6avzW4h5E9QXue
         jzEjpOX/5DjYHNSanv3vW/AH3nWFmRqZm7uWxCTan4Sa/arRf7QB5jX5cGIscl4EekBr
         j5GAGRBTRA0KZ7GS/OkQWw/+GvsSthjIhIeHhxVNv8a660/mE5udsm++yPKbKlhvWoLh
         mQgdHHQ03TzRLpkC3oAZ9Z26yPtv7aZB0rVgxhUGHYW0Pd7IbH2QqLDj3A9prYZ+dnt6
         ew+A==
X-Gm-Message-State: APjAAAWVIBBFQwIRaHmPK7FPFrTBkkuCOjL8KZOVvSRhH5eTlH1JpHPk
        fQjJqCIAzuEetyxE9p0gAE0kxvbOHmdgANhmr8REga49cxc3AA==
X-Google-Smtp-Source: APXvYqxTw3xSBxRTSiLN24Js63bOgMmhcPADiY48ZefHnEjeWGTtwY4ORy3LnrwXf6NPupQsYtNZlHCrLGT0TwSaKAk=
X-Received: by 2002:a05:6830:139a:: with SMTP id d26mr72215794otq.75.1577652248782;
 Sun, 29 Dec 2019 12:44:08 -0800 (PST)
MIME-Version: 1.0
From:   Patrick Erley <pat-lkml@erley.org>
Date:   Sun, 29 Dec 2019 12:43:57 -0800
Message-ID: <CAOB=O_jxu5JOe=JiYVW_VZ1rgs9+mdHpAHkscXkc4MVRLrBKDw@mail.gmail.com>
Subject: read time tree block corruption detected
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On a system where I've been tinkering with linux-next for years, my /
has got some errors.  When migrating from 5.1 to 5.2, I saw these
errors, but just ignored them and went back to 5.1, and continued my
tinkering.  Over the holidays, I decided to try to upgrade the kernel,
saw the errors again, and decided to look into them, finding the
tree-checker page on the kernel docs, and am writing this e-mail.

My / does not contain anything sensitive or important, as /home and
/usr/src are both subvolumes on a separate larger drive.

btrfs fi show:
Label: none  uuid: 815266d6-a8b9-4f63-a593-02fde178263f
Total devices 2 FS bytes used 93.81GiB
devid    1 size 115.12GiB used 115.11GiB path /dev/nvme0n1p2
devid    3 size 115.12GiB used 115.11GiB path /dev/sda3

Label: none  uuid: 4bd97711-b63c-40cb-bfa5-aa9c2868cf98
Total devices 1 FS bytes used 536.48GiB
devid    1 size 834.63GiB used 833.59GiB path /dev/sda5

Booting a more recent kernel, I get spammed with:
[    8.243899] BTRFS critical (device nvme0n1p2): corrupt leaf: root=5
block=303629811712 slot=30 ino=5380870, invalid inode generation: has
13221446351398931016 expect [0, 2997884]
[    8.243902] BTRFS error (device nvme0n1p2): block=303629811712 read
time tree block corruption detected

There are 6 corrupted inodes:
cat dmesg.foo  | grep "BTRFS critical" | sed -re
's:.*block=([0-9]*).*ino=([0-9]+).*:\1 \2:' | sort | uniq
303629811712 5380870
303712501760 3277548
303861395456 5909140
304079065088 2228479
304573444096 3539224
305039556608 1442149

and they all have the same value for the inode generation.  Before I
reboot into a livecd and btrfs check --repair, is there anything
interesting that a snapshot of the state would show?  I have 800gb
unpartitioned on the nvme, so backing up before is already in the
plans, and I could just as easily grab an image of the partitions
while I'm at it.
