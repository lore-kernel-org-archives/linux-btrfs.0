Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:40760 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3KNRtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 12:49:19 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A944C9A0368
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 10:49:19 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1384438193-13237-1-git-send-email-dsterba@suse.cz>
CC: David Sterba <dsterba@suse.cz>
References: <1384438193-13237-1-git-send-email-dsterba@suse.cz>
Message-ID: <20131114174913.3802.72670@localhost.localdomain>
Subject: Re: [PATCH] btrfs-progs: mkfs: enable extended refs by default
Date: Thu, 14 Nov 2013 12:49:13 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-11-14 09:09:53)
> The feature has been introduced in kernel 3.7 and enabling it by
> default is desired.
> 
> All features enabled by default are marked as such in
> 'mkfs.btrfs -O list-all' output.

Has anyone already tested syslinux and grub with extrefs enabled?

-chris
