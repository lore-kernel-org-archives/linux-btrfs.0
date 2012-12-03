Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:59626 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2LCUBg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Dec 2012 15:01:36 -0500
Date: Mon, 3 Dec 2012 12:01:36 -0800
From: Zach Brown <zab@zabbo.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 64KB "boot sector" gap
Message-ID: <20121203200136.GC1377@lenny.home.zabbo.net>
References: <B41E960E-A16B-4856-AFFE-FC5C99DDC7D5@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B41E960E-A16B-4856-AFFE-FC5C99DDC7D5@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 03, 2012 at 12:34:06AM -0700, Chris Murphy wrote:
> When creating a btrfs volume with mkfs.btrfs, I'm noticing that the
> first 64KB are completely blank. Is this gap expressly intended for
> installing a boot manager/loader?

If you want some historical reading check out the 'BTRFS partition
usage...' messages in:

https://oss.oracle.com/pipermail/btrfs-devel/2008-February/

- z
