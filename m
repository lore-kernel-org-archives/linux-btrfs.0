Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:34870 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932987Ab3HNU0c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 16:26:32 -0400
Message-ID: <520BE81E.1040408@sgi.com>
Date: Wed, 14 Aug 2013 15:27:10 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: add regression test for kernel bz 60673
References: <1375892154-11548-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1375892154-11548-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/07/2013 11:15 AM, Josef Bacik wrote:
> There was a problem with send trying to overwrite a file that wasn't actually
> the same.  This is a test to check this particular case where receive fails when
> it should succeed properly.  I tested this to verify it fails without my fix and
> passes with my fix.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   tests/btrfs/001     |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/001.out |    2 +
>   tests/btrfs/group   |    1 +
>   3 files changed, 113 insertions(+), 0 deletions(-)
>   create mode 100755 tests/btrfs/001
>   create mode 100644 tests/btrfs/001.out
>
Looks good but should have the btrfs folks look at this.

Note: The btrfs test numbers have been renumbered please update your 
xfstests git tree for future patches and updates.

Thanks
--Rich
