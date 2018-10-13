Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C03C28CF8
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 22:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FF7820659
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 22:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="c2qxyPbI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FF7820659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbeJNGHB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 02:07:01 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:43718 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbeJNGHB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 02:07:01 -0400
Received: by mail-lf1-f48.google.com with SMTP id p34-v6so11636813lfg.10
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2018 15:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:from:date:message-id:subject:to:cc;
        bh=1l3pUzEQRKggBSyzr8ch4WCbSwwzdIhBk/J6HsSAIH8=;
        b=c2qxyPbIzbLjqpg7SLyAShmpiCxlkK5YEjcwv842AXbD+F6nXxMYlokm9IyPHQpMOS
         NUGCWdyiqTMKSixgYHKG0mSyaS5OzFv45Q5GEKbHZTXMaVu42hnSEm8xEEKD3+2+0+7/
         iwwSleaXlsiFyKkCbUXhaYMNjVAKktZEfu6O8wzGu9kImON2m35of9LD3RSjIpQ5VVC5
         ba9VM9xTb11Z6ddRqkdYa+nFIn/bZt5uqHXxSiRzXwjgTUTVTX8aOFyydvtvUjhA78xK
         b+4vmA4AaN/erlkBThmoWlpyohaA9uBntUTWN6fTV5mhK0UuJEnNTBjrbRige5wTB9Mt
         I+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:cc;
        bh=1l3pUzEQRKggBSyzr8ch4WCbSwwzdIhBk/J6HsSAIH8=;
        b=ClhV2z3k5cCmCcR995+RnzkRUN4z9C0JJfXxCP3vcytgnPYaBsKd/ArfiXPDcoXPQi
         BMrf2hWtmOKh+5TSyVQGUwduCqlYH750Ho/VLvXt7AMW7t9cQUrlHh4bdA9vINge1D1i
         0q+Pk5OsB89J8axmZJc1aB2OXNQ/Gtc4rZsejHIynqX5f6BqNxvLj5lcVO26MAFtPhnR
         f42n6Nn+XIUU5YY2jUrizKFyIfTHFF9h/a2YAxBDfYWFOtGZvGFeqkfDjyD4ZEENfyQC
         n0/a9m7m4N3FPHT0sjRhxa7CzqgMZrWLGZTA0drwfrhKqWegeITbI00CIYhB1nZsvLED
         Z5sA==
X-Gm-Message-State: ABuFfoh2xMMY38T+ro1EqR41OEOwmS/gNACoUeysru5wFlBmknLlJRRz
        sv6vR0JvdhWUleZPITj4b8MrmF96pkFVs0o8keX66/MTVDw=
X-Google-Smtp-Source: ACcGV60Z4AgSxaZfIZHlajE3Eg2wAXl10HQ9VAmEa0PR+T+tBhi/5VYEEF/FOBXf245wAN6Jh6cxloHOPMrHooG+FFk=
X-Received: by 2002:a19:4bc7:: with SMTP id y190-v6mr6703240lfa.144.1539469696774;
 Sat, 13 Oct 2018 15:28:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Sat, 13 Oct 2018 15:28:16
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 13 Oct 2018 16:28:16 -0600
X-Google-Sender-Auth: WeEQQ_BrYHo52oLSn3Lj8Lj-HC0
Message-ID: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
Subject: reproducible builds with btrfs seed feature
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Anand Jain <anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Is it practical and desirable to make Btrfs based OS installation
images reproducible? Or is Btrfs simply too complex and
non-deterministic? [1]

The main three problems with Btrfs right now for reproducibility are:
a. many objects have uuids other than the volume uuid; and mkfs only
lets us set the volume uuid
b. atime, ctime, mtime, otime; and no way to make them all the same
c. non-deterministic allocation of file extents, compression, inode
assignment, logical and physical address allocation

I'm imagining reproducible image creation would be a mkfs feature that
builds on Btrfs seed and --rootdir concepts to constrain Btrfs
features to maybe make reproducible Btrfs volumes possible:

- No raid
- Either all objects needing uuids can have those uuids specified by
switch, or possibly a defined set of uuids expressly for this use
case, or possibly all of them can just be zeros (eek? not sure)
- A flag to set all times the same
- Possibly require that target block device is zero filled before
creation of the Btrfs
- Possibly disallow subvolumes and snapshots
- Require the resulting image is seed/ro and maybe also a new
compat_ro flag to enforce that such Btrfs file systems cannot be
modified after the fact.
- Enforce a consistent means of allocation and compression

The end result is creating two Btrfs volumes would yield image files
with matching hashes.

If I had to guess, the biggest challenge would be allocation. But it's
also possible that such an image may have problems with "sprouts". A
non-removable sprout seems fairly straightforward and safe; but if a
"reproducible build" type of seed is removed, it seems like removal
needs to be smart enough to refresh *all* uuids found in the sprout: a
hard break from the seed.

Competing file systems, ext4 with make_ext4 fork, and squashfs. At the
moment I'm thinking it might be easier to teach squashfs integrity
checking than to make Btrfs reproducible.  But then I also think
restricting Btrfs features, and applying some requirements to
constrain Btrfs to make it reproducible, really enhances the Btrfs
seed-sprout feature.

Any thoughts? Useful? Difficult to implement?

Squashfs might be a better fit for this use case *if* it can be taught
about integrity checking. It does per file checksums for the purpose
of deduplication but those checksums aren't retained for later
integrity checking.

[1] problems of reproducible system images
https://reproducible-builds.org/docs/system-images/

[2] purpose and motivation for reproducible builds
https://reproducible-builds.org/

[3] who is involved?
https://reproducible-builds.org/who/#Qubes%20OS




-- 
Chris Murphy
