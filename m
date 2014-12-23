Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58445 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbaLWUr4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 15:47:56 -0500
Date: Wed, 24 Dec 2014 07:47:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "gux.fnst" <gux.fnst@cn.fujitsu.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add regression test for remount with thread_pool
 resized
Message-ID: <20141223204752.GG4521@dastard>
References: <1401439971-18589-1-git-send-email-gux.fnst@cn.fujitsu.com>
 <54195C4F.8080108@cn.fujitsu.com>
 <549914B4.8020001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <549914B4.8020001@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 23, 2014 at 03:07:32PM +0800, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs: add regression test for remount with
> thread_pool resized
> From: gux.fnst <gux.fnst@cn.fujitsu.com>
> To: <fstests@vger.kernel.org>
> Date: 2014年09月17日 18:02
> >Hi,
> >
> >     Could anyone help to review this patch? Thanks!
> >
> >Regards,
> >Xing Gu
> >
> >On 05/30/2014 04:52 PM, Xing Gu wrote:
> >>Regression test for resizing 'thread_pool' when remount the fs.
> >>
> >>Signed-off-by: Xing Gu <gux.fnst@cn.fujitsu.com>
> >>---
> >>   tests/btrfs/055     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>   tests/btrfs/055.out |  1 +
> >>   tests/btrfs/group   |  1 +
> >>   3 files changed, 57 insertions(+)
> >>   create mode 100755 tests/btrfs/055
> >>   create mode 100644 tests/btrfs/055.out
> >>
> >>diff --git a/tests/btrfs/055 b/tests/btrfs/055
> >>new file mode 100755
> >>index 0000000..0a0dd34
> >>--- /dev/null
> >>+++ b/tests/btrfs/055
> >>@@ -0,0 +1,55 @@
> >>+#!/bin/bash
> >>+# FS QA Test No. btrfs/055
> >>+#
> >>+# Regression test for resizing 'thread_pool' when remount the fs.
> >>+#
> IMHO, it would be better to add the commit number for the regression
> and the fix commit number
> (Filipe Manana always does the great job).
> 
> For reference:
> Regresssion commit: 08a9ff3264181986d1d692a4e6fce3669700c9f8 (All my fault)
> Fix commit: 800ee2247f483b6d05ed47ef3bbc90b56451746c

That belongs in the commit message, not the test description.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
