Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:43900 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3JBLqH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Oct 2013 07:46:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 23FBC9A040C
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Oct 2013 05:46:07 -0600 (MDT)
Date: Wed, 2 Oct 2013 07:46:05 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at mm/page-writeback.c:2317!
Message-ID: <20131002114605.GB2562@localhost.localdomain>
References: <20131002170014.60dac0d9@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131002170014.60dac0d9@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 02, 2013 at 05:00:14PM +0900, Tomasz Chmielewski wrote:
> Just seen this on a server running 3.12.0-rc3 and btrfs.
> 
> Process writing to btrfs filesystem is stuck.
>

This is probably the bug that Liu Bo just fixed

https://patchwork.kernel.org/patch/2970751/

Thanks,

Josef 
