Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44713 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3KSOfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 09:35:47 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3E4D27C06B3
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 07:35:47 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: <harald@redhat.com>, <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1384857365-7719-1-git-send-email-harald@redhat.com>
CC: Harald Hoyer <harald@redhat.com>
References: <1384857365-7719-1-git-send-email-harald@redhat.com>
Message-ID: <20131119143532.5312.44372@localhost.localdomain>
Subject: Re: [PATCH] btrfs: allow mounting btrfs subvolumes with different ro/rw
 options
Date: Tue, 19 Nov 2013 09:35:32 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting harald@redhat.com (2013-11-19 05:36:05)
> From: Harald Hoyer <harald@redhat.com>
> 
[ create new vfsmounts with different states ]

Thanks for resending Harald.  I'll give this a shot and see if I can
find any problems with it.

-chris
