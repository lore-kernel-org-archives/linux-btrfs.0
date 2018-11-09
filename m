Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE69DC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66048208A3
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:58:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66048208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=techsingularity.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbeKJHkr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 02:40:47 -0500
Received: from outbound-smtp12.blacknight.com ([46.22.139.17]:44775 "EHLO
        outbound-smtp12.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbeKJHkr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 02:40:47 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2018 02:40:43 EST
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp12.blacknight.com (Postfix) with ESMTPS id 567901C1903
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 21:51:50 +0000 (GMT)
Received: (qmail 17413 invoked from network); 9 Nov 2018 21:51:50 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[37.228.229.69])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 9 Nov 2018 21:51:50 -0000
Date:   Fri, 9 Nov 2018 21:51:48 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Josef Bacik <jbacik@fb.com>
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: [Regression bisected] btrfs: always wait on ordered extents at fsync
 time
Message-ID: <20181109215148.GF23260@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Josef (and review/signed-off path),

I noticed a particularly large regression when reviewing results from
v4.18 to v4.18 (33.81% regression with 5 reaim clients). An automatic
bisection resolved to commit b5e6c3e170b7 ("btrfs: always wait on ordered
extents at fsync time"). I won't pretend to understand the patch or btrfs
in general but the changelog talks about cgroup priority so I'm guessing
that an impact on the !cgroup case is unintentional. Unfortunately, as
I'm about to travel, I didn't attempt a revert and a test comparing 4.18,
4.19 and 4.20-rc1 is a few hours away so this could potentially be fixed
already but I didn't spot any obvious Fixes commit.

The bisecting machine is a 1-socket skylake machine with a Toshiba
MG03ACA1 disk (rotary storage). The mmtests configuration is based on
configs/config-global-dhp__reaim-io-new_dbase and it uses a patched
version of reaim that, among other things, stops it sending signals at
high frequency and syncing like crazy (still does normal sensible
syncs). The configuration was updated to use a dedicated partition built
with a fresh btrfs filesystem at each bisection point.

A partial output of the report (detailed per commit reports are missing)
is below. Note it includes the "last good" and "penultimate good" results
as these results are usually a strong indicator as whether the bisection
is correct or not.  This particular one looks reasonably accurate.

Bisect parameters
=================
CONFIG_AUTO=openSUSE-LEAP-15.0
MACHINE=delboy
BISECT_REVERSE=no
BISECT_MMTESTS_TEST=reaim
BISECT_CONFIG=global-dhp__reaim-io-new_dbase-btrfs
BISECT_GOOD=v4.18
BISECT_BAD=v4.19
BISECT_LOGDIR=/srv/marvin/impera/bisections-sigma-delboy-global-dhp__reaim-io-new_dbase-btrfs-openSUSE-LEAP-15.0-openSUSE-LEAP-15.0-v4.18..v4.19
BISECT_COMPARE=Hmean
BISECT_PREFER=Higher
BISECT_CLIENT="new_dbase-5"
BISECT_REBOOT_CLEAN=no

Last good/First bad commit
==========================
Last good commit: 16d1c062c7de2999ea7be61d31070fa4ce3d99c4
First bad commit: b5e6c3e170b77025b5f6174258c7ad71eed2d4de
From b5e6c3e170b77025b5f6174258c7ad71eed2d4de Mon Sep 17 00:00:00 2001
From: Josef Bacik <jbacik@fb.com>
Date: Wed, 23 May 2018 11:58:33 -0400
Subject: [PATCH] btrfs: always wait on ordered extents at fsync time
There's a priority inversion that exists currently with btrfs fsync.  In
some cases we will collect outstanding ordered extents onto a list and
only wait on them at the very last second.  However this "very last
second" falls inside of a transaction handle, so if we are in a lower
priority cgroup we can end up holding the transaction open for longer
than needed, so if a high priority cgroup is also trying to fsync()
it'll see latency.
Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
 fs/btrfs/file.c | 56 ++++----------------------------------------------------
 1 file changed, 4 insertions(+), 52 deletions(-)

Comparison
==========
                                      initial                initial                   last                  penup                  first
                                   good-v4.18              bad-v4.19          good-16d1c062          good-bd3c685e           bad-b5e6c3e1
Min       new_dbase-1       712.80 (   0.00%)      715.28 (   0.35%)      703.87 (  -1.25%)      828.42 (  16.22%)      790.28 (  10.87%)
Min       new_dbase-5      6118.81 (   0.00%)     4049.80 ( -33.81%)     5659.34 (  -7.51%)     6424.12 (   4.99%)     4170.04 ( -31.85%)
Min       new_dbase-9     15711.86 (   0.00%)    10554.08 ( -32.83%)    16553.57 (   5.36%)    16028.82 (   2.02%)    10716.76 ( -31.79%)
Min       new_dbase-13    26959.73 (   0.00%)    18554.27 ( -31.18%)    27233.90 (   1.02%)    23629.41 ( -12.35%)    18903.53 ( -29.88%)
Min       new_dbase-17    39348.31 (   0.00%)    27359.38 ( -30.47%)    36992.96 (  -5.99%)    36734.27 (  -6.64%)    26732.82 ( -32.06%)
Min       new_dbase-21    46185.05 (   0.00%)    36150.42 ( -21.73%)    45697.18 (  -1.06%)    45219.51 (  -2.09%)    36251.40 ( -21.51%)
Min       new_dbase-25    53832.75 (   0.00%)    43398.88 ( -19.38%)    52372.88 (  -2.71%)    52551.02 (  -2.38%)    43398.88 ( -19.38%)
Min       new_dbase-29    60547.30 (   0.00%)    50914.77 ( -15.91%)    57442.31 (  -5.13%)    59148.51 (  -2.31%)    51947.83 ( -14.20%)
Min       new_dbase-33    66000.00 (   0.00%)    58603.45 ( -11.21%)    65365.38 (  -0.96%)    65365.38 (  -0.96%)    56650.00 ( -14.17%)
Hmean     new_dbase-1       789.27 (   0.00%)      824.88 (   4.51%)      817.89 (   3.63%)      890.49 *  12.82%*      839.22 (   6.33%)
Hmean     new_dbase-5      6234.86 (   0.00%)     4236.36 * -32.05%*     6541.07 (   4.91%)     6611.04 *   6.03%*     4272.68 * -31.47%*
Hmean     new_dbase-9     17424.81 (   0.00%)    10876.03 * -37.58%*    17348.72 (  -0.44%)    17381.25 (  -0.25%)    10966.09 * -37.07%*
Hmean     new_dbase-13    27703.45 (   0.00%)    18832.63 * -32.02%*    28071.28 (   1.33%)    27233.90 (  -1.69%)    19183.38 * -30.75%*
Hmean     new_dbase-17    40099.24 (   0.00%)    27661.93 * -31.02%*    38010.13 *  -5.21%*    38120.47 *  -4.93%*    27911.80 * -30.39%*
Hmean     new_dbase-21    47434.21 (   0.00%)    37207.57 * -21.56%*    47748.34 (   0.66%)    47089.98 (  -0.73%)    36785.72 * -22.45%*
Hmean     new_dbase-25    55257.51 (   0.00%)    44498.85 * -19.47%*    54826.12 (  -0.78%)    54172.51 (  -1.96%)    44886.70 * -18.77%*
Hmean     new_dbase-29    63105.63 (   0.00%)    52588.03 * -16.67%*    60959.18 (  -3.40%)    62013.84 (  -1.73%)    52557.19 * -16.72%*
Hmean     new_dbase-33    67218.20 (   0.00%)    58976.29 * -12.26%*    67844.31 (   0.93%)    68482.20 (   1.88%)    58874.13 * -12.41%*
Stddev    new_dbase-1        78.12 (   0.00%)       97.07 ( -24.26%)       84.87 (  -8.64%)       57.38 (  26.55%)       36.90 (  52.77%)
Stddev    new_dbase-5       177.59 (   0.00%)      146.32 (  17.61%)      556.74 (-213.49%)      130.44 (  26.55%)       90.93 (  48.80%)
Stddev    new_dbase-9      1011.69 (   0.00%)      184.92 (  81.72%)      699.60 (  30.85%)      835.46 (  17.42%)      230.76 (  77.19%)
Stddev    new_dbase-13      487.52 (   0.00%)      271.12 (  44.39%)      901.52 ( -84.92%)     2173.85 (-345.90%)      205.63 (  57.82%)
Stddev    new_dbase-17      573.14 (   0.00%)      339.51 (  40.76%)     1123.04 ( -95.95%)     1388.46 (-142.26%)      721.58 ( -25.90%)
Stddev    new_dbase-21     1124.24 (   0.00%)      990.16 (  11.93%)     2130.54 ( -89.51%)     1314.60 ( -16.93%)      488.21 (  56.57%)
Stddev    new_dbase-25     1450.84 (   0.00%)      737.96 (  49.14%)     1694.76 ( -16.81%)     1906.68 ( -31.42%)      907.20 (  37.47%)
Stddev    new_dbase-29     1677.03 (   0.00%)     1146.60 (  31.63%)     2526.21 ( -50.64%)     1905.54 ( -13.63%)      647.29 (  61.40%)
Stddev    new_dbase-33     1399.15 (   0.00%)      252.62 (  81.95%)     2623.85 ( -87.53%)     2324.35 ( -66.13%)     1359.44 (   2.84%)
CoeffVar  new_dbase-1         9.82 (   0.00%)       11.65 ( -18.59%)       10.28 (  -4.72%)        6.42 (  34.60%)        4.39 (  55.30%)
CoeffVar  new_dbase-5         2.85 (   0.00%)        3.45 ( -21.22%)        8.46 (-197.14%)        1.97 (  30.71%)        2.13 (  25.26%)
CoeffVar  new_dbase-9         5.79 (   0.00%)        1.70 (  70.64%)        4.03 (  30.43%)        4.80 (  17.13%)        2.10 (  63.67%)
CoeffVar  new_dbase-13        1.76 (   0.00%)        1.44 (  18.19%)        3.21 ( -82.39%)        7.94 (-351.19%)        1.07 (  39.08%)
CoeffVar  new_dbase-17        1.43 (   0.00%)        1.23 (  14.12%)        2.95 (-106.61%)        3.64 (-154.61%)        2.58 ( -80.81%)
CoeffVar  new_dbase-21        2.37 (   0.00%)        2.66 ( -12.27%)        4.46 ( -88.05%)        2.79 ( -17.77%)        1.33 (  43.99%)
CoeffVar  new_dbase-25        2.62 (   0.00%)        1.66 (  36.82%)        3.09 ( -17.70%)        3.52 ( -34.00%)        2.02 (  23.01%)
CoeffVar  new_dbase-29        2.66 (   0.00%)        2.18 (  17.94%)        4.14 ( -55.81%)        3.07 ( -15.60%)        1.23 (  53.63%)
CoeffVar  new_dbase-33        2.08 (   0.00%)        0.43 (  79.42%)        3.86 ( -85.65%)        3.39 ( -62.96%)        2.31 ( -10.92%)
Max       new_dbase-1       872.88 (   0.00%)      984.08 (  12.74%)      916.91 (   5.04%)      961.12 (  10.11%)      877.84 (   0.57%)
Max       new_dbase-5      6546.61 (   0.00%)     4452.45 ( -31.99%)     7087.16 (   8.26%)     6732.03 (   2.83%)     4401.71 ( -32.76%)
Max       new_dbase-9     18296.05 (   0.00%)    11013.86 ( -39.80%)    18296.05 (   0.00%)    18058.44 (  -1.30%)    11213.71 ( -38.71%)
Max       new_dbase-13    28288.73 (   0.00%)    19220.10 ( -32.06%)    29214.55 (   3.27%)    28899.28 (   2.16%)    19452.78 ( -31.23%)
Max       new_dbase-17    40879.38 (   0.00%)    28241.94 ( -30.91%)    39795.45 (  -2.65%)    39946.77 (  -2.28%)    28548.91 ( -30.16%)
Max       new_dbase-21    48973.58 (   0.00%)    38170.59 ( -22.06%)    50302.33 (   2.71%)    48245.35 (  -1.49%)    37508.67 ( -23.41%)
Max       new_dbase-25    57011.07 (   0.00%)    45175.44 ( -20.76%)    56181.82 (  -1.45%)    57222.22 (   0.37%)    45710.06 ( -19.82%)
Max       new_dbase-29    64700.36 (   0.00%)    53819.82 ( -16.82%)    64236.56 (  -0.72%)    63779.36 (  -1.42%)    53339.29 ( -17.56%)
Max       new_dbase-33    69604.10 (   0.00%)    59284.88 ( -14.83%)    72063.60 (   3.53%)    71557.89 (   2.81%)    59982.35 ( -13.82%)
BHmean-50 new_dbase-1       869.20 (   0.00%)      908.82 (   4.56%)      892.42 (   2.67%)      944.23 (   8.63%)      874.11 (   0.57%)
BHmean-50 new_dbase-5      6377.71 (   0.00%)     4358.25 ( -31.66%)     7014.76 (   9.99%)     6717.39 (   5.33%)     4364.41 ( -31.57%)
BHmean-50 new_dbase-9     18087.80 (   0.00%)    10992.09 ( -39.23%)    18058.44 (  -0.16%)    18058.44 (  -0.16%)    11179.90 ( -38.19%)
BHmean-50 new_dbase-13    28090.91 (   0.00%)    19105.83 ( -31.99%)    29056.06 (   3.44%)    28847.40 (   2.69%)    19359.04 ( -31.08%)
BHmean-50 new_dbase-17    40642.17 (   0.00%)    27941.49 ( -31.25%)    38983.30 (  -4.08%)    39496.24 (  -2.82%)    28433.02 ( -30.04%)
BHmean-50 new_dbase-21    48425.37 (   0.00%)    38170.59 ( -21.18%)    50108.11 (   3.47%)    48245.35 (  -0.37%)    37239.60 ( -23.10%)
BHmean-50 new_dbase-25    56697.25 (   0.00%)    45175.44 ( -20.32%)    56079.86 (  -1.09%)    56079.86 (  -1.09%)    45575.22 ( -19.62%)
BHmean-50 new_dbase-29    64467.63 (   0.00%)    53658.68 ( -16.77%)    62994.73 (  -2.28%)    63779.36 (  -1.07%)    53260.03 ( -17.38%)
BHmean-50 new_dbase-33    68321.61 (   0.00%)    59198.84 ( -13.35%)    70324.14 (   2.93%)    70689.77 (   3.47%)    59806.45 ( -12.46%)
BHmean-95 new_dbase-1       811.02 (   0.00%)      857.74 (   5.76%)      852.41 (   5.10%)      907.49 (  11.89%)      852.41 (   5.10%)
BHmean-95 new_dbase-5      6264.57 (   0.00%)     4285.72 ( -31.59%)     6806.17 (   8.65%)     6659.48 (   6.30%)     4299.13 ( -31.37%)
BHmean-95 new_dbase-9     17913.04 (   0.00%)    10959.61 ( -38.82%)    17559.59 (  -1.97%)    17755.79 (  -0.88%)    11030.24 ( -38.42%)
BHmean-95 new_dbase-13    27895.83 (   0.00%)    18903.53 ( -32.24%)    28288.74 (   1.41%)    28313.66 (   1.50%)    19254.65 ( -30.98%)
BHmean-95 new_dbase-17    40291.47 (   0.00%)    27738.62 ( -31.16%)    38273.22 (  -5.01%)    38483.52 (  -4.49%)    28222.97 ( -29.95%)
BHmean-95 new_dbase-21    47757.13 (   0.00%)    37481.59 ( -21.52%)    48290.23 (   1.12%)    47582.03 (  -0.37%)    36921.76 ( -22.69%)
BHmean-95 new_dbase-25    55625.56 (   0.00%)    44782.61 ( -19.49%)    55475.76 (  -0.27%)    54593.64 (  -1.86%)    45274.73 ( -18.61%)
BHmean-95 new_dbase-29    63779.36 (   0.00%)    53023.67 ( -16.86%)    61906.74 (  -2.94%)    62774.08 (  -1.58%)    52711.77 ( -17.35%)
BHmean-95 new_dbase-33    67529.80 (   0.00%)    59070.24 ( -12.53%)    68493.70 (   1.43%)    69308.41 (   2.63%)    59457.73 ( -11.95%)
BHmean-99 new_dbase-1       811.02 (   0.00%)      857.74 (   5.76%)      852.41 (   5.10%)      907.49 (  11.89%)      852.41 (   5.10%)
BHmean-99 new_dbase-5      6264.57 (   0.00%)     4285.72 ( -31.59%)     6806.17 (   8.65%)     6659.48 (   6.30%)     4299.13 ( -31.37%)
BHmean-99 new_dbase-9     17913.04 (   0.00%)    10959.61 ( -38.82%)    17559.59 (  -1.97%)    17755.79 (  -0.88%)    11030.24 ( -38.42%)
BHmean-99 new_dbase-13    27895.83 (   0.00%)    18903.53 ( -32.24%)    28288.74 (   1.41%)    28313.66 (   1.50%)    19254.65 ( -30.98%)
BHmean-99 new_dbase-17    40291.47 (   0.00%)    27738.62 ( -31.16%)    38273.22 (  -5.01%)    38483.52 (  -4.49%)    28222.97 ( -29.95%)
BHmean-99 new_dbase-21    47757.13 (   0.00%)    37481.59 ( -21.52%)    48290.23 (   1.12%)    47582.03 (  -0.37%)    36921.76 ( -22.69%)
BHmean-99 new_dbase-25    55625.56 (   0.00%)    44782.61 ( -19.49%)    55475.76 (  -0.27%)    54593.64 (  -1.86%)    45274.73 ( -18.61%)
BHmean-99 new_dbase-29    63779.36 (   0.00%)    53023.67 ( -16.86%)    61906.74 (  -2.94%)    62774.08 (  -1.58%)    52711.77 ( -17.35%)
BHmean-99 new_dbase-33    67529.80 (   0.00%)    59070.24 ( -12.53%)    68493.70 (   1.43%)    69308.41 (   2.63%)    59457.73 ( -11.95%)

Git log
=======
git bisect start
# good: [94710cac0ef4ee177a63b5227664b38c95bbf703] Linux 4.18
git bisect good 94710cac0ef4ee177a63b5227664b38c95bbf703
# bad: [84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d] Linux 4.19
git bisect bad 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d
# good: [94710cac0ef4ee177a63b5227664b38c95bbf703] Linux 4.18
git bisect good 94710cac0ef4ee177a63b5227664b38c95bbf703
# bad: [db06f826ec12bf0701ea7fc0a3c0aa00b84417c8] Merge tag 'clk-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux
git bisect bad db06f826ec12bf0701ea7fc0a3c0aa00b84417c8
# bad: [0a957467c5fd46142bc9c52758ffc552d4c5e2f7] x86: i8259: Add missing include file
git bisect bad 0a957467c5fd46142bc9c52758ffc552d4c5e2f7
# bad: [958f338e96f874a0d29442396d6adf9c1e17aa2d] Merge branch 'l1tf-final' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 958f338e96f874a0d29442396d6adf9c1e17aa2d
# good: [85a0b791bc17f7a49280b33e2905d109c062a47b] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect good 85a0b791bc17f7a49280b33e2905d109c062a47b
# bad: [a1a4f841ec4585185c0e75bfae43a18b282dd316] Merge tag 'for-4.19-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
git bisect bad a1a4f841ec4585185c0e75bfae43a18b282dd316
# good: [a66b4cd1e7163adb327838a3c81faaf6a9330d5a] Merge branch 'work.open3' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good a66b4cd1e7163adb327838a3c81faaf6a9330d5a
# bad: [ac8a866af17edc692b50cbdd2aec612de4205c8f] btrfs: qgroup: Drop root parameter from update_qgroup_limit_item
git bisect bad ac8a866af17edc692b50cbdd2aec612de4205c8f
# bad: [893bf4b115c713738df05bb557f8fba14f07c077] btrfs: print more details when checking tree block finds a problem
git bisect bad 893bf4b115c713738df05bb557f8fba14f07c077
# bad: [5a98ec0141805a0ff9adb18fd18834a906637f2f] btrfs: Remove fs_info from btrfs_remove_block_group
git bisect bad 5a98ec0141805a0ff9adb18fd18834a906637f2f
# bad: [edf57cbf2b030781885e339f32e35a470d2f8eba] btrfs: Fix a C compliance issue
git bisect bad edf57cbf2b030781885e339f32e35a470d2f8eba
# bad: [e7175a692765940f3ac3f0c005b9a766a59303d7] btrfs: remove the wait ordered logic in the log_one_extent path
git bisect bad e7175a692765940f3ac3f0c005b9a766a59303d7
# good: [bd3c685ed9fd3763615a51a70e19ff08a456e3e1] btrfs: Document __btrfs_inc_extent_ref
git bisect good bd3c685ed9fd3763615a51a70e19ff08a456e3e1
# bad: [b5e6c3e170b77025b5f6174258c7ad71eed2d4de] btrfs: always wait on ordered extents at fsync time
git bisect bad b5e6c3e170b77025b5f6174258c7ad71eed2d4de
# good: [16d1c062c7de2999ea7be61d31070fa4ce3d99c4] btrfs: Fix comment in lookup_inline_extent_backref
git bisect good 16d1c062c7de2999ea7be61d31070fa4ce3d99c4
# first bad commit: [b5e6c3e170b77025b5f6174258c7ad71eed2d4de] btrfs: always wait on ordered extents at fsync time

Impera log
==========
impera::Fri 9 Nov 14:49:20 GMT 2018::reaim delboy :good: v4.18 scaled 6505+-158 sigma good actual 6505.26+-158.76 Hmean-new_dbase-5
impera::Fri 9 Nov 15:12:22 GMT 2018::reaim delboy :bad: v4.19 scaled 4236+-146 sigma bad actual 4236.36+-146.32 Hmean-new_dbase-5
impera::Fri 9 Nov 15:34:56 GMT 2018::reaim delboy :good: v4.18 scaled 6234+-177 sigma 6347 actual 6234.86+-177.59 Hmean-new_dbase-5
impera::Fri 9 Nov 15:58:14 GMT 2018::reaim delboy :bad: db06f826ec12bf0701ea7fc0a3c0aa00b84417c8 scaled 4264+-102 sigma 6347 actual 4264.42+-102.96 Hmean-new_dbase-5
impera::Fri 9 Nov 16:21:26 GMT 2018::reaim delboy :bad: 0a957467c5fd46142bc9c52758ffc552d4c5e2f7 scaled 4265+-104 sigma 6347 actual 4265.60+-104.39 Hmean-new_dbase-5
impera::Fri 9 Nov 16:44:36 GMT 2018::reaim delboy :bad: 958f338e96f874a0d29442396d6adf9c1e17aa2d scaled 4260+-108 sigma 6347 actual 4260.89+-108.14 Hmean-new_dbase-5
impera::Fri 9 Nov 17:07:30 GMT 2018::reaim delboy :good: 85a0b791bc17f7a49280b33e2905d109c062a47b scaled 6554+-297 sigma 6347 actual 6554.94+-297.09 Hmean-new_dbase-5
impera::Fri 9 Nov 17:30:38 GMT 2018::reaim delboy :bad: a1a4f841ec4585185c0e75bfae43a18b282dd316 scaled 4315+-126 sigma 6347 actual 4315.64+-126.31 Hmean-new_dbase-5
impera::Fri 9 Nov 17:53:00 GMT 2018::reaim delboy :good: a66b4cd1e7163adb327838a3c81faaf6a9330d5a scaled 6376+-352 sigma 6347 actual 6376.39+-352.02 Hmean-new_dbase-5
impera::Fri 9 Nov 18:16:06 GMT 2018::reaim delboy :bad: ac8a866af17edc692b50cbdd2aec612de4205c8f scaled 4271+-112 sigma 6347 actual 4271.50+-112.50 Hmean-new_dbase-5
impera::Fri 9 Nov 18:39:14 GMT 2018::reaim delboy :bad: 893bf4b115c713738df05bb557f8fba14f07c077 scaled 4382+-78 sigma 6347 actual 4382.98+-78.95 Hmean-new_dbase-5
impera::Fri 9 Nov 19:02:38 GMT 2018::reaim delboy :bad: 5a98ec0141805a0ff9adb18fd18834a906637f2f scaled 4275+-99 sigma 6347 actual 4275.04+-99.84 Hmean-new_dbase-5
impera::Fri 9 Nov 19:25:53 GMT 2018::reaim delboy :bad: edf57cbf2b030781885e339f32e35a470d2f8eba scaled 4263+-26 sigma 6347 actual 4263.25+-26.42 Hmean-new_dbase-5
impera::Fri 9 Nov 19:49:12 GMT 2018::reaim delboy :bad: e7175a692765940f3ac3f0c005b9a766a59303d7 scaled 4189+-99 sigma 6347 actual 4189.26+-99.48 Hmean-new_dbase-5
impera::Fri 9 Nov 20:11:30 GMT 2018::reaim delboy :good: bd3c685ed9fd3763615a51a70e19ff08a456e3e1 scaled 6611+-130 sigma 6347 actual 6611.04+-130.44 Hmean-new_dbase-5
impera::Fri 9 Nov 20:34:41 GMT 2018::reaim delboy :bad: b5e6c3e170b77025b5f6174258c7ad71eed2d4de scaled 4272+-90 sigma 6347 actual 4272.68+-90.93 Hmean-new_dbase-5
impera::Fri 9 Nov 20:57:11 GMT 2018::reaim delboy :good: 16d1c062c7de2999ea7be61d31070fa4ce3d99c4 scaled 6541+-556 sigma 6347 actual 6541.07+-556.74 Hmean-new_dbase-5

-- 
Mel Gorman
SUSE Labs
