Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33339 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756966AbbGHDfV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 23:35:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [GIT PULL] Fix for btrfs/070 checksum error
To: Chris Mason <clm@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <559C9A75.60506@cn.fujitsu.com>
Date: Wed, 8 Jul 2015 11:35:17 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Sorry for the late pull request, this one should be sent on Monday. :(

This patchset is meant to fix an annoying bug triggered by btrfs/070 and 
some other concurrency scrub + IO load test.

The bug itself is triggered by chance and took Zhao Lei quite a long 
time to trace and debug it.

Although previous patchset sent to mail-list has some problem, it turned 
out that's rebasing typo, and can be fixed quite easy.

We have spend a whole weekend running tests this time to ensure the 
patch is OK.

The fix itself is small enough and only fixes a long standing problem.
IMHO it is OK for the late fix merge window.

So please merge the following branch:
https://github.com/adam900710/linux.git  for_chris_4.2_070_fix

Thanks,
Qu
