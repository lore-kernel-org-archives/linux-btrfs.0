Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44269 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3KOT5Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 14:57:25 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 691CA7C0699
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 12:57:25 -0700 (MST)
Date: Fri, 15 Nov 2013 14:57:23 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Valentina Giusti <valentina.giusti@microon.de>
CC: <chris.mason@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: remove unused parameters from wait_for_commit and
 btrfs_wait_marked_extents
Message-ID: <20131115195723.GB5128@localhost.localdomain>
References: <1384083572-15443-1-git-send-email-valentina.giusti@microon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <1384083572-15443-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 10, 2013 at 12:39:32PM +0100, Valentina Giusti wrote:
> This patch fixes the following warnings:
> fs/btrfs/transaction.c: In function ‘wait_for_commit’:
> fs/btrfs/transaction.c:560:57: warning: unused parameter ‘root’ [-Wunused-parameter]
> fs/btrfs/transaction.c: In function ‘btrfs_wait_marked_extents’:
> fs/btrfs/transaction.c:811:50: warning: unused parameter ‘mark’ [-Wunused-parameter]
> 

This causes us to fail to build.  Thanks,

Josef
