Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AEBDC04EBF
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 09:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E4E220817
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 09:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d87X8V8t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E4E220817
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbeKQUGJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 17 Nov 2018 15:06:09 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38242 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbeKQUGI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Nov 2018 15:06:08 -0500
Received: by mail-pl1-f193.google.com with SMTP id e5so2279110plb.5
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Nov 2018 01:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1cKTpRrCY7ZCtD131/FFb44Aj6x1nGqb3dkp8s75Mk4=;
        b=d87X8V8twUL6DPdm3cLGQC/KA6NInNw0mSG7osOgtVU/Y4FTbmN+vp5LOIZ0UyLZdm
         bzD3XHs+GSBDUi9yRLEZPdE9/BQ+XIiwUjQ5rId4DwIXedEq6MEJfrgRj4LJYeTzh9ag
         uCpykjvWNJVcSy3olJCBoN9Ar85rnaLcqlM1hMiXOyFFm63oCLjQZyEvBDRsz7Ab9Ov8
         X4VXQdNvTMOzTd107MmSiwYQmnePWgUL9dYhJAszYKHoAcH1VEUztM6IJCA2O2Pm1iEF
         gXdfYPqslksAz8Q9fsQ0wExKOqpcQGWvrw9O6voxtEZVTFn96x9osQmnW6oZWFxWbX1w
         faGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1cKTpRrCY7ZCtD131/FFb44Aj6x1nGqb3dkp8s75Mk4=;
        b=YAxyqufjegFfdB6+vqWd5RyIDEOcq+qLUL7XQ06kXpSbRZE/wTh+hnAUywNHT7+fXh
         nE0mYUjdKiLBHaJTBdWetq0RcIsDIs/jVvjgG3I4ig1iNYdh4S0SlmaBHI8NMAoiJ2U0
         6dBxEiB2G0cchipc62/oW23BnrfzdvEMLObSkBiVUdHrDJqcHdYBj6iD58D9rihpzRW1
         VJxqsiO/vrjnx3MPu6+iVgknuENNVqeMfbdnedaN0Qwet/duSzSAB1/H3ekELVea37LK
         HfHnjIgzjyzBxo4jH/f5JTAcdvVdr+i3xEp1/dB1QhPUomBXV9ge2F0GCHus4kvOLZza
         cFWg==
X-Gm-Message-State: AGRZ1gKkGWL3R1gDlUag2LZCyl9anRhZ+qNU8qm3UNPiuTlEDffCtSNm
        2Q0ivlc+n8EJBdfKbaQbSW9uuUxXFovrZ30nk7ag/n2I
X-Google-Smtp-Source: AJdET5cLceT8eVZVORGnw4HC2mNR45GM2cuYBn8SdeH9SZTUTnVB/as1/aP416Wdb5mvTjhgaZ+57yxnCSyrHZ6YRXs=
X-Received: by 2002:a17:902:7d89:: with SMTP id a9mr14455001plm.242.1542448201272;
 Sat, 17 Nov 2018 01:50:01 -0800 (PST)
MIME-Version: 1.0
From:   Serhat Sevki Dincer <jfcgauss@gmail.com>
Date:   Sat, 17 Nov 2018 12:49:50 +0300
Message-ID: <CAPqC6xSUYc-hphH2UeG3b=JxBheJy6bejtwLc=8m5znugwH0Xw@mail.gmail.com>
Subject: Re: btrfs convert problem
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

On my second attempt to convert my 698 GiB usb HDD from ext4 to btrfs
with btrfs-progs 4.19 from Manjaro (kernel 4.14.80):

I identified bad files with
$ find . -type f -exec cat {} > /dev/null \;
This revealed 6 corrupted files, I deleted them. Tried it again with
no error message.

Then I checked HDD with
$ sudo fsck.ext4 -f /dev/sdb1
e2fsck 1.44.4 (18-Aug-2018)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
HDD: 763513/45744128 files (0.3% non-contiguous), 131674747/182970301 blocks
It is mountable & usable.

Now my attempt to convert
$ LC_ALL=en_US.utf8 sudo strace -f -s 10 -a 4 -o convert-strace.log
btrfs-convert /dev/sdb1
create btrfs filesystem:
    blocksize: 4096
    nodesize:  16384
    features:  extref, skinny-metadata (default)
creating ext2 image file
Unable to find block group for 0
Unable to find block group for 0
Unable to find block group for 0
ctree.c:2244: split_leaf: BUG_ON `1` triggered, value 1
btrfs-convert(+0x162d6)[0x561fbd26b2d6]
btrfs-convert(btrfs_search_slot+0xf21)[0x561fbd26c881]
btrfs-convert(btrfs_csum_file_block+0x499)[0x561fbd27e8e9]
btrfs-convert(+0xe6f5)[0x561fbd2636f5]
btrfs-convert(main+0x194f)[0x561fbd26296f]
/usr/lib/libc.so.6(__libc_start_main+0xf3)[0x7f658a93a223]
btrfs-convert(_start+0x2e)[0x561fbd26328e]
Aborted

It crashed :) The log is 2.4G, I compressed it and put it at
https://drive.google.com/drive/folders/0B5oVWFBM47D9aVpJY2s4UTdMdUU

What else can I do to debug further?
Thanks..
