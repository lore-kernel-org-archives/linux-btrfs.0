Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35283 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756832AbdIHTvh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 15:51:37 -0400
Received: by mail-lf0-f49.google.com with SMTP id d17so7767074lfe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 12:51:36 -0700 (PDT)
Received: from [192.168.0.10] (m37-2-41-92.cust.tele2.se. [37.2.41.92])
        by smtp.gmail.com with ESMTPSA id l14sm421598lfb.71.2017.09.08.12.51.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Sep 2017 12:51:34 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: A L <crimsoncottage@gmail.com>
Subject: btrfs check --clear-space-cache v1 fails if not --clear-space-cache
 v2 first
Message-ID: <67a9a252-22ad-7057-fd91-c8abec0f4df9@gmail.com>
Date: Fri, 8 Sep 2017 21:51:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seems to be some inconsistency with btrfs check --clear-space-cache v1. 
It only worked after clearing v2 space cache. See below result.

Background. Since some time I was running with space_cache mount option. 
I recently changed to space_cache=v2 and used "clear_cache" mount option 
to clear out the old v1 cache. From reading this mailings list I found 
that I should really use btrfs check --clear-space-cache v1 to truly 
clear the old version space cache.

btrfs-progs-4.13
kernel-4.13

    # btrfs check --clear-space-cache v1 /dev/sdb1
    couldn't open RDWR because of unsupported option features (3).
    ERROR: cannot open file system

    # btrfs check /dev/sdb1
    Checking filesystem on /dev/sdb1
    UUID: e0ea1dc2-948a-488c-ad46-98236939b373
    checking extents
    checking free space tree
    cache and super generation don't match, space cache will be invalidated
    checking fs roots
    checking csums
    checking root refs
    found 305286168601 bytes used, no error found
    total csum bytes: 246501768
    total tree bytes: 415334400
    total fs tree bytes: 87130112
    total extent tree bytes: 45481984
    btree space waste bytes: 65894664
    file data blocks allocated: 5691562237952
      referenced 341901901824

    # btrfs check --clear-space-cache v1 /dev/sdb1
    couldn't open RDWR because of unsupported option features (3).
    ERROR: cannot open file system

    # btrfs check --clear-space-cache v2 /dev/sdb1
    Checking filesystem on /dev/sdb1
    UUID: e0ea1dc2-948a-488c-ad46-98236939b373
    Clear free space cache v2
    free space cache v2 cleared

    # btrfs check --clear-space-cache v2 /dev/sdb1
    Checking filesystem on /dev/sdb1
    UUID: e0ea1dc2-948a-488c-ad46-98236939b373
    no free space cache v2 to clear

    # btrfs check --clear-space-cache v1 /dev/sdb1
    Checking filesystem on /dev/sdb1
    UUID: e0ea1dc2-948a-488c-ad46-98236939b373
    Clearing free space cache
    Free space cache cleared

    # btrfs check /dev/sdb1
    Checking filesystem on /dev/sdb1
    UUID: e0ea1dc2-948a-488c-ad46-98236939b373
    checking extents
    checking free space tree
    checking fs roots
    checking csums
    checking root refs
    found 305220087844 bytes used, no error found
    total csum bytes: 246501768
    total tree bytes: 415236096
    total fs tree bytes: 87130112
    total extent tree bytes: 45481984
    btree space waste bytes: 65905890
    file data blocks allocated: 5691495915520
      referenced 341835579392

Now, why do I not get "no free space cache v1 to clear" when running it 
several times more?

    # btrfs check --clear-space-cache v1 /dev/sdb1
    Checking filesystem on /dev/sdb1
    UUID: e0ea1dc2-948a-488c-ad46-98236939b373
    Clearing free space cache

The exact same happen on my other volumes, both single devices and RAID1.
