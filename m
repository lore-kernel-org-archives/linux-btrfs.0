Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33202 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbbADE7U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 23:59:20 -0500
Message-ID: <54A8C89D.4000504@oracle.com>
Date: Sun, 04 Jan 2015 12:59:09 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: btrfs: fix up 001.out
References: <1420055304-4633-1-git-send-email-anand.jain@oracle.com> <CAL3q7H5YBzTwkRycRyuoj_K82rX3hn+BeYU2L-Wzik-dKMur_A@mail.gmail.com>
In-Reply-To: <CAL3q7H5YBzTwkRycRyuoj_K82rX3hn+BeYU2L-Wzik-dKMur_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>
> The test should just ignore the output and check if the snapshot
> creation command succeeds.
> See how more recent tests do it - they are calling
> _run_btrfs_util_prog (which calls run_check).

How nice we have _run_btrfs_util_prog. it was needed for a long time Thanks,
v2 is out.
Anand

