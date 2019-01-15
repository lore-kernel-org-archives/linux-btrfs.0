Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6047DC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36F7F20645
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732401AbfAORDy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:03:54 -0500
Received: from wp158.webpack.hosteurope.de ([80.237.132.165]:55834 "EHLO
        wp158.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732214AbfAORDx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 12:03:53 -0500
X-Greylist: delayed 1842 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2019 12:03:52 EST
Received: from ip5b41acd8.dynamic.kabel-deutschland.de ([91.65.172.216] helo=[192.168.0.31]); authenticated
        by wp158.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1gjReG-0003nw-PE; Tue, 15 Jan 2019 17:33:08 +0100
To:     linux-btrfs@vger.kernel.org
From:   Christian Schneider <christian@ch-sc.de>
Subject: issue mounting volume
Message-ID: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
Date:   Tue, 15 Jan 2019 17:33:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;christian@ch-sc.de;1547571832;193fbc6c;
X-HE-SMSGID: 1gjReG-0003nw-PE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hello all, after a power failure I have issues mounting a btrfs volume:

  mount /dev/md42
mount: /home: wrong fs type, bad option, bad superblock on /dev/md42, 
missing codepage or helper program, or other error

dmesg
[...]
[ 4322.061000] BTRFS info (device md42): use lzo compression, level 0
[ 4322.061004] BTRFS info (device md42): disk space caching is enabled
[ 4322.061005] BTRFS info (device md42): has skinny extents
[ 4323.016007] BTRFS error (device md42): parent transid verify failed 
on 448888832 wanted 68773 found 68768
[ 4323.025656] BTRFS error (device md42): parent transid verify failed 
on 448888832 wanted 68773 found 68771
[ 4323.025665] BTRFS error (device md42): failed to read block groups: -5
[ 4323.036088] BTRFS error (device md42): open_ctree failed

adding -o ro,usebackuproot doesn't change anything, same mount error, 
same error messages in dmesg.

Also tried btrfs check with this error.
btrfs check /dev/md42
Opening filesystem to check...
parent transid verify failed on 448888832 wanted 68773 found 68768
parent transid verify failed on 448888832 wanted 68773 found 68768
parent transid verify failed on 448888832 wanted 68773 found 68771
parent transid verify failed on 448888832 wanted 68773 found 68771
Ignoring transid failure
leaf parent key incorrect 448888832
ERROR: cannot open file system

I also tried btrfs-find-root with this result:
btrfs-find-root /dev/md42
parent transid verify failed on 448888832 wanted 68773 found 68768
parent transid verify failed on 448888832 wanted 68773 found 68768
parent transid verify failed on 448888832 wanted 68773 found 68771
parent transid verify failed on 448888832 wanted 68773 found 68771
Ignoring transid failure
leaf parent key incorrect 448888832
Superblock thinks the generation is 68921
Superblock thinks the level is 1
Found tree root at 629129216 gen 68921 level 1
Well block 625803264(gen: 68917 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 602259456(gen: 68899 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 600997888(gen: 68898 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 581926912(gen: 68885 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 582320128(gen: 68884 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 578306048(gen: 68882 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 577339392(gen: 68881 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 575225856(gen: 68880 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 574341120(gen: 68879 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 574947328(gen: 68878 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 572555264(gen: 68877 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 571179008(gen: 68876 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 569393152(gen: 68875 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 568164352(gen: 68874 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 566050816(gen: 68873 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 565002240(gen: 68872 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 563920896(gen: 68871 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 564346880(gen: 68870 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 561446912(gen: 68869 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 560267264(gen: 68868 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 560545792(gen: 68867 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 557858816(gen: 68866 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
Well block 556924928(gen: 68865 level: 1) seems good, but 
generation/level doesn't match, want gen: 68921 level: 1
[...]

The last line repeats with different block numbers with decreasing gen 
and level sometimes 0.

A simple
btrfs filesystem show /dev/md42
Label: none  uuid: 8c6746f0-944a-45c5-90f3-622724d15998
         Total devices 1 FS bytes used 1.63TiB
         devid    1 size 7.26TiB used 1.90TiB path /dev/md42

for me, seems to be ok.

Is there something I could try to recover from this?
Any help is welcome, as it happened during backup creation, and the 
backup volume suffers from the same issue.

Additional info of system:
uname -a
uname -a
Linux jane 4.19.6-gentoo #1 SMP PREEMPT Sat Dec 15 13:26:24 CET 2018 
x86_64 Intel(R) Core(TM) i7-4785T CPU @ 2.20GHz GenuineIntel GNU/Linux

btrfs --version
btrfs-progs v4.19.1

BR, Christian
