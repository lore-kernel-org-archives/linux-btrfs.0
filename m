Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([205.185.120.7]:52224 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754825AbdJQDJx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 23:09:53 -0400
Received: from [IPv6:2601:6c5:8000:1480:54ff:ba2b:b29:792c] ([IPv6:2601:6c5:8000:1480:54ff:ba2b:b29:792c])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id v9G8Gtwc012135
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 04:16:59 -0400
To: linux-btrfs@vger.kernel.org
From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Unmountable fs - missing generation?
Message-ID: <b8b0b87b-25ac-9edf-02a2-aa93e51c1f56@nuclearwinter.com>
Date: Mon, 16 Oct 2017 11:16:53 -0400
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


