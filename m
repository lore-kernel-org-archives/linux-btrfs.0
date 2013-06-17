Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59146 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3FQRjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 13:39:45 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2279B7C0696
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 11:39:45 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130617134955.GB15861@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
References: <20130617134955.GB15861@redhat.com>
Message-ID: <20130617173942.15057.63201@localhost.localdomain>
Subject: Re: [3.10-rc6] WARNING: at fs/btrfs/inode.c:7961
 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
Date: Mon, 17 Jun 2013 13:39:42 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Dave Jones (2013-06-17 09:49:55)
> Hit this while running this script in a loop..
> https://github.com/kernelslacker/io-tests/blob/master/setup.sh
> [34385.251507] ------------[ cut here ]------------
> [34385.254068] WARNING: at fs/btrfs/inode.c:7961 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()

Thanks Dave, how long did you have to run the script to trigger it?

-chris
