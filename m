Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:60924 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3HTSsP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 14:48:15 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 52D4A9A06AB
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 12:48:15 -0600 (MDT)
Date: Tue, 20 Aug 2013 14:48:13 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Chris Mason <chris.mason@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: reuse kbasename helper
Message-ID: <20130820184813.GI3990@localhost.localdomain>
References: <1376307670-27010-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <1376307670-27010-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 12, 2013 at 02:41:10PM +0300, Andy Shevchenko wrote:
> To get name of the file from a pathname let's use kbasename() helper. It allows
> to simplify code a bit.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Introduces a compile error

fs/btrfs/send.c: In function ‘record_ref’:
fs/btrfs/send.c:2615:12: warning: assignment discards ‘const’ qualifier from
pointer target type [enabled by default]
fs/btrfs/send.c:2605:8: warning: unused variable ‘tmp’ [-Wunused-variable]

Thanks,

Josef
