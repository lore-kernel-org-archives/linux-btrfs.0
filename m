Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:54079 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbdJROSv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 10:18:51 -0400
Received: by mail-ua0-f171.google.com with SMTP id s41so3654754uab.10
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 07:18:51 -0700 (PDT)
Received: from [10.0.0.120] (c-76-101-203-225.hsd1.fl.comcast.net. [76.101.203.225])
        by smtp.gmail.com with ESMTPSA id x14sm4990805uab.13.2017.10.18.07.18.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Oct 2017 07:18:49 -0700 (PDT)
From: Larkin Lowrey <llowrey@gmail.com>
Subject: Unmountable fs. No root for superblock generation
To: linux-btrfs@vger.kernel.org
Message-ID: <4b86aa36-8a9d-5af6-06a9-351db3015107@gmail.com>
Date: Wed, 18 Oct 2017 10:18:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am unable to mount one my my filesystems.  The superblock thinks the 
latest generation is 2220927 but I can't seem to find a root with that 
number. I can find 2220926 and 2220928 but not 2220927. Is there 
anything that I can do to recover this FS?

# btrfs check /dev/Cached/Backups
checksum verify failed on 159057884594176 found 15284E33 wanted C8C5B54E
checksum verify failed on 159057884594176 found 15284E33 wanted C8C5B54E
checksum verify failed on 159057884594176 found 472037C9 wanted 9ACDCCB4
checksum verify failed on 159057884594176 found 472037C9 wanted 9ACDCCB4
Csum didn't match
Couldn't setup extent tree
Couldn't open file system

# btrfs-find-root -g 2220927 /dev/Cached/Backups
Couldn't setup extent tree
Couldn't setup device tree
Superblock thinks the generation is 2220927
Superblock thinks the level is 2

Found tree root at 159057884577792 gen 2220927 level 2
Well block 101489031790592(gen: 2220928 level: 2) seems good, but 
generation/level doesn't match, want gen: 2220927 level: 2

# btrfs check --tree-root 159057884577792  /dev/Cached/Backups
checksum verify failed on 159057884594176 found 15284E33 wanted C8C5B54E
checksum verify failed on 159057884594176 found 15284E33 wanted C8C5B54E
checksum verify failed on 159057884594176 found 472037C9 wanted 9ACDCCB4
checksum verify failed on 159057884594176 found 472037C9 wanted 9ACDCCB4
Csum didn't match
Couldn't setup extent tree
Couldn't open file system

# btrfs check --tree-root 101489031790592 /dev/Cached/Backups
parent transid verify failed on 101489031790592 wanted 2220927 found 2220928
parent transid verify failed on 101489031790592 wanted 2220927 found 2220928
parent transid verify failed on 101489031790592 wanted 2220927 found 2220928
parent transid verify failed on 101489031790592 wanted 2220927 found 2220928
Ignoring transid failure
parent transid verify failed on 159057595138048 wanted 2220927 found 2220920
parent transid verify failed on 159057595138048 wanted 2220927 found 2220920
parent transid verify failed on 159057595138048 wanted 2220927 found 2220920
parent transid verify failed on 159057595138048 wanted 2220927 found 2220920
Ignoring transid failure
parent transid verify failed on 158652658122752 wanted 2220927 found 2220911
parent transid verify failed on 158652658122752 wanted 2220927 found 2220911
parent transid verify failed on 158652658122752 wanted 2220927 found 2220911
parent transid verify failed on 158652658122752 wanted 2220927 found 2220911
Ignoring transid failure
Checking filesystem on /dev/Cached/Backups
UUID: 1b213dfd-6486-47d8-8459-bc5825882023
checking extents
parent transid verify failed on 116329711550464 wanted 2220928 found 2220921
parent transid verify failed on 116329711550464 wanted 2220928 found 2220921
parent transid verify failed on 116329711550464 wanted 2220928 found 2220921
parent transid verify failed on 116329711550464 wanted 2220928 found 2220921
Ignoring transid failure
parent transid verify failed on 116325928206336 wanted 2220928 found 2220921
parent transid verify failed on 116325928206336 wanted 2220928 found 2220921
parent transid verify failed on 116325928206336 wanted 2220928 found 2220921
parent transid verify failed on 116325928206336 wanted 2220928 found 2220921
Ignoring transid failure
parent transid verify failed on 116329892970496 wanted 2220928 found 2220921
parent transid verify failed on 116329892970496 wanted 2220928 found 2220921
parent transid verify failed on 116329892970496 wanted 2220928 found 2220921
parent transid verify failed on 116329892970496 wanted 2220928 found 2220921
Ignoring transid failure
parent transid verify failed on 116325929943040 wanted 2220928 found 2220921
parent transid verify failed on 116325929943040 wanted 2220928 found 2220921
parent transid verify failed on 116325929943040 wanted 2220928 found 2220921
parent transid verify failed on 116325929943040 wanted 2220928 found 2220921
Ignoring transid failure
parent transid verify failed on 116325932679168 wanted 2220928 found 2220921
parent transid verify failed on 116325932679168 wanted 2220928 found 2220921
parent transid verify failed on 116325932679168 wanted 2220928 found 2220921
parent transid verify failed on 116325932679168 wanted 2220928 found 2220921
Ignoring transid failure
parent transid verify failed on 116010673373184 wanted 2220928 found 2220921
parent transid verify failed on 116010673373184 wanted 2220928 found 2220921
parent transid verify failed on 116010673373184 wanted 2220928 found 2220921
parent transid verify failed on 116010673373184 wanted 2220928 found 2220921
Ignoring transid failure
parent transid verify failed on 116329479405568 wanted 2220928 found 2220921
parent transid verify failed on 116329479405568 wanted 2220928 found 2220921
parent transid verify failed on 116329479405568 wanted 2220928 found 2220921
parent transid verify failed on 116329479405568 wanted 2220928 found 2220921
Ignoring transid failure
parent transid verify failed on 116480660914176 wanted 2220928 found 2220921
parent transid verify failed on 116480660914176 wanted 2220928 found 2220921
parent transid verify failed on 116480660914176 wanted 2220928 found 2220921
parent transid verify failed on 116480660914176 wanted 2220928 found 2220921
Ignoring transid failure
checksum verify failed on 159058014814208 found 406AAC5F wanted C07B44A6
checksum verify failed on 159058014814208 found 406AAC5F wanted C07B44A6
parent transid verify failed on 159058014814208 wanted 2220927 found 2220920
checksum verify failed on 159058014814208 found 406AAC5F wanted C07B44A6
Csum didn't match
parent transid verify failed on 116329821028352 wanted 2220928 found 2220921
parent transid verify failed on 116329821028352 wanted 2220928 found 2220921
parent transid verify failed on 116329821028352 wanted 2220928 found 2220921
parent transid verify failed on 116329821028352 wanted 2220928 found 2220921
Ignoring transid failure
parent transid verify failed on 114958975139840 wanted 2220928 found 2220920
parent transid verify failed on 114958975139840 wanted 2220928 found 2220920
parent transid verify failed on 114958975139840 wanted 2220928 found 2220920
parent transid verify failed on 114958975139840 wanted 2220928 found 2220920
Ignoring transid failure
leaf parent key incorrect 114958975139840
bad block 114958975139840
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 116329711550464 wanted 2220928 found 2220921
Ignoring transid failure
leaf parent key incorrect 116329711550464


