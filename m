Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA3EC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 23:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D29992081C
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 23:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D29992081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=techsingularity.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbeKJIsS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 03:48:18 -0500
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:49712 "EHLO
        outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727746AbeKJIsS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 03:48:18 -0500
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2018 03:48:17 EST
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp02.blacknight.com (Postfix) with ESMTPS id B0DDF98979
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 22:56:43 +0000 (UTC)
Received: (qmail 16863 invoked from network); 9 Nov 2018 22:56:43 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[37.228.229.69])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 9 Nov 2018 22:56:43 -0000
Date:   Fri, 9 Nov 2018 22:56:42 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Josef Bacik <jbacik@fb.com>
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [Regression bisected] btrfs: always wait on ordered extents at
 fsync time
Message-ID: <20181109225642.GG23260@techsingularity.net>
References: <20181109215148.GF23260@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20181109215148.GF23260@techsingularity.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 09, 2018 at 09:51:48PM +0000, Mel Gorman wrote:
> Unfortunately, as
> I'm about to travel, I didn't attempt a revert and a test comparing 4.18,
> 4.19 and 4.20-rc1 is a few hours away so this could potentially be fixed
> already but I didn't spot any obvious Fixes commit.
> 

Still here a few hours later but the regression still appears to exist
in mainline and the comparison report is below.  While there are slightly
differences, the regressions are well outside multiples of the stddev and
co-efficient of variance so I'm fairly sure it's real. The one positive
thing is that the actual standard deviation is lower so the results are
more stable but that is a thin silver lining.

reaim
                                       4.18.0                 4.19.0             4.20.0-rc1
                                      vanilla                vanilla                vanilla
Min       new_dbase-1       703.07 (   0.00%)      752.74 (   7.06%)      739.23 (   5.14%)
Min       new_dbase-5      6293.28 (   0.00%)     4158.82 ( -33.92%)     4164.42 ( -33.83%)
Min       new_dbase-9     16803.63 (   0.00%)    10948.82 ( -34.84%)    10927.31 ( -34.97%)
Min       new_dbase-13    25343.85 (   0.00%)    18640.37 ( -26.45%)    18094.59 ( -28.60%)
Min       new_dbase-17    38203.64 (   0.00%)    27430.81 ( -28.20%)    27793.65 ( -27.25%)
Min       new_dbase-21    45697.18 (   0.00%)    34700.53 ( -24.06%)    35170.73 ( -23.04%)
Min       new_dbase-25    54593.64 (   0.00%)    44269.34 ( -18.91%)    44142.86 ( -19.14%)
Min       new_dbase-29    60752.54 (   0.00%)    51797.69 ( -14.74%)    50484.51 ( -16.90%)
Min       new_dbase-33    59631.58 (   0.00%)    57610.17 (  -3.39%)    57286.52 (  -3.93%)
Hmean     new_dbase-1       787.46 (   0.00%)      821.81 (   4.36%)      866.52 (  10.04%)
Hmean     new_dbase-5      6437.50 (   0.00%)     4269.14 * -33.68%*     4314.44 * -32.98%*
Hmean     new_dbase-9     17305.54 (   0.00%)    11101.80 * -35.85%*    11075.27 * -36.00%*
Hmean     new_dbase-13    27570.35 (   0.00%)    19065.02 * -30.85%*    18885.75 * -31.50%*
Hmean     new_dbase-17    39377.81 (   0.00%)    27926.64 * -29.08%*    28181.33 * -28.43%*
Hmean     new_dbase-21    47434.21 (   0.00%)    36785.71 * -22.45%*    36150.42 * -23.79%*
Hmean     new_dbase-25    56593.41 (   0.00%)    45387.78 * -19.80%*    44808.59 * -20.82%*
Hmean     new_dbase-29    61503.09 (   0.00%)    52250.73 * -15.04%*    51176.47 * -16.79%*
Hmean     new_dbase-33    66343.53 (   0.00%)    58235.29 * -12.22%*    58637.15 * -11.62%*
Stddev    new_dbase-1       125.91 (   0.00%)       57.02 (  54.71%)       88.32 (  29.86%)
Stddev    new_dbase-5       174.01 (   0.00%)      130.71 (  24.88%)      107.34 (  38.32%)
Stddev    new_dbase-9       537.99 (   0.00%)      114.10 (  78.79%)      154.87 (  71.21%)
Stddev    new_dbase-13     1502.62 (   0.00%)      352.32 (  76.55%)      503.48 (  66.49%)
Stddev    new_dbase-17      935.76 (   0.00%)      322.83 (  65.50%)      279.50 (  70.13%)
Stddev    new_dbase-21     1389.92 (   0.00%)     1425.14 (  -2.53%)      805.66 (  42.04%)
Stddev    new_dbase-25     1672.09 (   0.00%)      875.75 (  47.63%)      529.71 (  68.32%)
Stddev    new_dbase-29      678.85 (   0.00%)      340.66 (  49.82%)      852.63 ( -25.60%)
Stddev    new_dbase-33     3958.22 (   0.00%)      632.39 (  84.02%)      845.17 (  78.65%)
CoeffVar  new_dbase-1        15.72 (   0.00%)        6.91 (  56.03%)       10.10 (  35.73%)
CoeffVar  new_dbase-5         2.70 (   0.00%)        3.06 ( -13.25%)        2.49 (   7.96%)
CoeffVar  new_dbase-9         3.11 (   0.00%)        1.03 (  66.92%)        1.40 (  54.99%)
CoeffVar  new_dbase-13        5.44 (   0.00%)        1.85 (  66.02%)        2.66 (  50.99%)
CoeffVar  new_dbase-17        2.38 (   0.00%)        1.16 (  51.34%)        0.99 (  58.25%)
CoeffVar  new_dbase-21        2.93 (   0.00%)        3.87 ( -32.14%)        2.23 (  23.92%)
CoeffVar  new_dbase-25        2.95 (   0.00%)        1.93 (  34.67%)        1.18 (  59.97%)
CoeffVar  new_dbase-29        1.10 (   0.00%)        0.65 (  40.93%)        1.67 ( -50.92%)
CoeffVar  new_dbase-33        5.95 (   0.00%)        1.09 (  81.74%)        1.44 (  75.77%)
Max       new_dbase-1      1019.80 (   0.00%)      900.87 ( -11.66%)      973.23 (  -4.57%)
Max       new_dbase-5      6717.39 (   0.00%)     4446.04 ( -33.81%)     4414.29 ( -34.29%)
Max       new_dbase-9     18058.44 (   0.00%)    11259.11 ( -37.65%)    11304.88 ( -37.40%)
Max       new_dbase-13    28795.70 (   0.00%)    19547.45 ( -32.12%)    19452.78 ( -32.45%)
Max       new_dbase-17    40407.69 (   0.00%)    28241.94 ( -30.11%)    28548.91 ( -29.35%)
Max       new_dbase-21    48973.58 (   0.00%)    38283.19 ( -21.83%)    37080.00 ( -24.29%)
Max       new_dbase-25    59195.40 (   0.00%)    46676.74 ( -21.15%)    45307.92 ( -23.46%)
Max       new_dbase-29    62445.99 (   0.00%)    52711.76 ( -15.59%)    52557.18 ( -15.84%)
Max       new_dbase-33    69132.20 (   0.00%)    59284.88 ( -14.24%)    59457.73 ( -13.99%)

-- 
Mel Gorman
SUSE Labs
