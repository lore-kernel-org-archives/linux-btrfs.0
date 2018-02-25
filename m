Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0050.outbound.protection.outlook.com ([104.47.116.50]:16704
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751576AbeBYKQb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Feb 2018 05:16:31 -0500
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Help with leaf parent key incorrect
Date: Sun, 25 Feb 2018 10:16:27 +0000
Message-ID: <MEXPR01MB03427A142FC749C4C2126A0A9EC20@MEXPR01MB0342.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I was running dedupe on my filesystem and something went wrong overnight, by the time I noticed the fs was readonly.
When trying to check it this is what I get:
vm-server ~ # btrfs check /dev/mapper/a-backup--a
parent transid verify failed on 2371034071040 wanted 62977 found 62893
parent transid verify failed on 2371034071040 wanted 62977 found 62893
parent transid verify failed on 2371034071040 wanted 62977 found 62893
parent transid verify failed on 2371034071040 wanted 62977 found 62893
Ignoring transid failure
leaf parent key incorrect 2371034071040
ERROR: cannot open file system

Is there a way to fix this? I'm using kernel 4.15.5

This is the last part of dmesg

[  +0.000002] BTRFS error (device dm-6): parent transid verify failed on 2374016368640 wanted 63210 found 63208
[  +0.000004] BTRFS error (device dm-6): parent transid verify failed on 2374016368640 wanted 63210 found 63208
[  +1.107963] BTRFS error (device dm-6): parent transid verify failed on 2374016368640 wanted 63210 found 63208
[  +0.000005] BTRFS error (device dm-6): parent transid verify failed on 2374016368640 wanted 63210 found 63208
[  +1.473598] BTRFS error (device dm-6): parent transid verify failed on 2373996298240 wanted 63210 found 63208
[  +0.000004] BTRFS error (device dm-6): parent transid verify failed on 2373996298240 wanted 63210 found 63208
[  +0.001927] BTRFS error (device dm-6): parent transid verify failed on 2373996298240 wanted 63210 found 63208
[  +0.000003] BTRFS error (device dm-6): parent transid verify failed on 2373996298240 wanted 63210 found 63208
[  +0.000060] BTRFS error (device dm-6): parent transid verify failed on 2373996298240 wanted 63210 found 63208
[  +0.000001] BTRFS error (device dm-6): parent transid verify failed on 2373996298240 wanted 63210 found 63208
[  +2.676048] verify_parent_transid: 10362 callbacks suppressed
[  +0.000002] BTRFS error (device dm-6): parent transid verify failed on 2373991677952 wanted 63210 found 63208
[  +0.000003] BTRFS error (device dm-6): parent transid verify failed on 2373991677952 wanted 63210 found 63208
[  +0.078432] BTRFS error (device dm-6): parent transid verify failed on 2373996232704 wanted 63210 found 63208
[  +0.000004] BTRFS error (device dm-6): parent transid verify failed on 2373996232704 wanted 63210 found 63208
[  +0.000043] BTRFS error (device dm-6): parent transid verify failed on 2373996232704 wanted 63210 found 63208
[  +0.000001] BTRFS error (device dm-6): parent transid verify failed on 2373996232704 wanted 63210 found 63208
[  +0.058638] BTRFS error (device dm-6): parent transid verify failed on 2373996232704 wanted 63210 found 63208
[  +0.000004] BTRFS error (device dm-6): parent transid verify failed on 2373996232704 wanted 63210 found 63208
[  +0.139174] BTRFS error (device dm-6): parent transid verify failed on 2373996232704 wanted 63210 found 63208
[  +0.000004] BTRFS error (device dm-6): parent transid verify failed on 2373996232704 wanted 63210 found 63208
[Feb25 20:48] BTRFS info (device dm-6): using free space tree
[  +0.000002] BTRFS error (device dm-6): Remounting read-write after error is not allowed
[Feb25 20:49] BTRFS error (device dm-6): cleaner transaction attach returned -30
[  +0.238718] BTRFS warning (device dm-6): page private not zero on page 1596642967552
[  +0.000003] BTRFS warning (device dm-6): page private not zero on page 1596642971648
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596642975744
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596642979840
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596643672064
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596643676160
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596643680256
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596643684352
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596643704832
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596643708928
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596643713024
[  +0.000002] BTRFS warning (device dm-6): page private not zero on page 1596643717120
[  +0.000028] BTRFS warning (device dm-6): page private not zero on page 2363051098112
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2363051102208
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2363051106304
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2363051110400
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2368056344576
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2368056348672
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2368056352768
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2368056356864
[  +0.000007] BTRFS warning (device dm-6): page private not zero on page 2368124452864
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2368124456960
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2368124461056
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2368124465152
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2370526740480
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2370526744576
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2370526748672
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2370526752768
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2370531917824
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2370531921920
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2370531926016
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2370531930112
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371211624448
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371211628544
[  +0.000005] BTRFS warning (device dm-6): page private not zero on page 2371211632640
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371211636736
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371521855488
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371521859584
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2371521863680
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371521867776
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371522543616
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371522547712
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371522551808
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2371522555904
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371735420928
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371735425024
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371735429120
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2371735433216
[  +0.000007] BTRFS warning (device dm-6): page private not zero on page 2371835379712
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371835383808
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371835387904
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2371835392000
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2372929699840
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2372929703936
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2372929708032
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2372929712128
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373108727808
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373108731904
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2373108736000
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373108740096
[  +0.000004] BTRFS warning (device dm-6): page private not zero on page 2373987221504
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373987225600
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373987229696
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373987233792
[  +0.000008] BTRFS warning (device dm-6): page private not zero on page 2373987696640
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373987700736
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373987704832
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2373987708928
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373989564416
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373989568512
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373989572608
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373989576704
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2373990318080
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373990322176
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373990326272
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373990330368
[  +0.000004] BTRFS warning (device dm-6): page private not zero on page 2373991677952
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373991682048
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373991686144
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373991690240
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996134400
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2373996138496
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996142592
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996146688
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996232704
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996236800
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2373996240896
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996244992
[  +0.000005] BTRFS warning (device dm-6): page private not zero on page 2373996298240
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996302336
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996306432
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2373996310528
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2374002032640
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2374002036736
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2374002040832
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2374002044928
[  +0.000000] BTRFS warning (device dm-6): page private not zero on page 2374016368640
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2374016372736
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2374016376832
[  +0.000001] BTRFS warning (device dm-6): page private not zero on page 2374016380928
[  +3.303065] BTRFS info (device dm-6): enabling ssd optimizations
[  +0.000003] BTRFS info (device dm-6): use zstd compression, level 0
[  +0.000002] BTRFS info (device dm-6): using free space tree
[  +0.000000] BTRFS info (device dm-6): has skinny extents
[  +0.623207] verify_parent_transid: 28 callbacks suppressed
[  +0.000002] BTRFS error (device dm-6): parent transid verify failed on 2371034071040 wanted 62977 found 62893
[  +0.007895] BTRFS error (device dm-6): parent transid verify failed on 2371034071040 wanted 62977 found 62893
[  +0.000003] BTRFS error (device dm-6): failed to read block groups: -5
[  +0.037630] BTRFS error (device dm-6): open_ctree failed
