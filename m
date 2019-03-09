Return-Path: <SRS0=Falb=RM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E71C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Mar 2019 21:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B008420657
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Mar 2019 21:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmVUf+fs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfCIVgB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Mar 2019 16:36:01 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:43336 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfCIVgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2019 16:36:01 -0500
Received: by mail-ot1-f48.google.com with SMTP id n71so834207ota.10
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2019 13:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qt+4GC3FOIqKbm8sX899Tyk/bKFwF1X6Tbc8wz2Mwx8=;
        b=OmVUf+fsGacPjghyGI225HD5CAYZbb3N1vPLx1cW4LLG2apfgxWikG3CoUuHh+JPba
         KQcXyZLIIhoBgi0rY/QnLI2WLf2oYxjezEb/YawiE/eUpzL4NnIccscp14sZZ/WU8k49
         igOr20yc/QDgugYjTxJLWNQc18Vel1PZEXig7fyn23LfmXaij6KzVfWNZuSLijoEa1eX
         rAVp6R2fe+592FWKzxlJCyiejznQToOIe2bhJ2qvjzAewd6WsXvb1VLS5HafkyQVhabA
         z80N/8q9LOpc3jEvzbdU3RSaLmyJ0s9L2TpzDOgNS0ChxZq4qlYjxu3ceLl3YrwbtgmM
         L2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qt+4GC3FOIqKbm8sX899Tyk/bKFwF1X6Tbc8wz2Mwx8=;
        b=RbbNT3b+1Mtu8aiQ7SPrq4EY0EWnvl0arY72nfHw02tZsbgrRksPZ4CEOLQwrkatoz
         sEykibYzVDCQ63uTAGj6qT5USb0/3osG/XWQRTGYYXja7MAQ193V020cnmEOXh97w52F
         s3Z5oXY+GEziBms/UXt05HdVijImdAtd8G6omtbBUw/VztoS7Evrt+eSK3nGhMUoHX8C
         N2Q9gwzy5SchDwjF3mycuAtBkoZvKdFlvIjKwSuTIxc5w9MZYFqN3sqiFFiSZ/tb8Erj
         3TYbKF5SE31/Vc6N2aaa6h7/lOW6I1xmx2v7qHFMuyNlTBgwWGtIyZtLKRblAdHrGeAQ
         mASA==
X-Gm-Message-State: APjAAAX/EP9x+H4P/jzwqpqjEOALBArOKXh6zYfAyenOkqjwiOzAiSV2
        7SgxgCPmwdS1kfuqpe22jzMMh+iy/rk9FWo+Gn5K3Hib
X-Google-Smtp-Source: APXvYqwXWTx8ct26EcO83ZphNzpgAUteJKRmGDBoOAfsbJrrqxq8AqoOXG9r/I35Snk91ggYNU0z3pw0UHKcBqR621Q=
X-Received: by 2002:a9d:6c18:: with SMTP id f24mr16078961otq.2.1552167359247;
 Sat, 09 Mar 2019 13:35:59 -0800 (PST)
MIME-Version: 1.0
From:   Glenn Trigg <ggtrigg@gmail.com>
Date:   Sun, 10 Mar 2019 08:35:48 +1100
Message-ID: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
Subject: help request for an unmountable raid1 filesystem
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I had some random machine freezing events which I suspected was due to
issues with a raid1 filesystem and kernel module crashes. I attempted
to use the information available to get the filesystem into a good
state where "btrfs check" and "btrfs scrub" would not have any errors,
however I fear things have become worse.

The current state of things is that the filesystem won't mount at all now.

% mount -r /dev/sda1 /data
mount: /data: can't read superblock on /dev/sda1.

and dmesg says:

[15944.017629] BTRFS info (device sda1): disk space caching is enabled
[15944.017632] BTRFS info (device sda1): has skinny extents
[15944.024480] BTRFS info (device sda1): bdev /dev/sda1 errs: wr 0, rd
0, flush 0, corrupt 1, gen 0
[15944.024487] BTRFS info (device sda1): bdev /dev/sdb1 errs: wr 0, rd
0, flush 0, corrupt 4, gen 0
[15944.029292] BTRFS error (device sda1): parent transid verify failed
on 628168376320 wanted 37601 found 37700
[15944.029466] BTRFS error (device sda1): parent transid verify failed
on 628168376320 wanted 37601 found 37700

Other system information is:
% uname -a
Linux izen 4.18.0-16-generic #17-Ubuntu SMP Fri Feb 8 00:06:57 UTC
2019 x86_64 x86_64 x86_64 GNU/Linux

% btrfs --version
btrfs-progs v4.16.1

% btrfs fi show
Label: 'root'  uuid: 65fd7f11-4f60-435f-928b-6d15f12bc417
Total devices 1 FS bytes used 101.75GiB
devid    1 size 232.88GiB used 232.85GiB path /dev/nvme0n1p1

Label: 'data'  uuid: d5e50511-3e31-4de6-ba37-c5841895be9f
Total devices 2 FS bytes used 830.44GiB
devid    1 size 1.82TiB used 669.03GiB path /dev/sda1
devid    2 size 1.82TiB used 817.06GiB path /dev/sdb1

% btrfs check /dev/sda1
Checking filesystem on /dev/sda1
UUID: d5e50511-3e31-4de6-ba37-c5841895be9f
checking extents
parent transid verify failed on 628168343552 wanted 28163 found 37700
parent transid verify failed on 628168343552 wanted 28163 found 37700
parent transid verify failed on 628168343552 wanted 28163 found 37700
parent transid verify failed on 628168343552 wanted 28163 found 37700
Ignoring transid failure
bad block 628168343552
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 root dir 256 not found
ERROR: errors found in fs roots
found 528138240 bytes used, error(s) found
total csum bytes: 0
total tree bytes: 1785856
total fs tree bytes: 1064960
total extent tree bytes: 81920
btree space waste bytes: 606983
file data blocks allocated: 215220224
 referenced 215220224

% btrfs rescue super-recover /dev/sda1
All supers are valid, no need to recover

Where do I go from here?

Regards,
Glenn
