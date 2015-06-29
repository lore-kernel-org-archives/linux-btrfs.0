Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:56497
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbbF2HUo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 03:20:44 -0400
Received: from tux.wizards.de (p4FF5828B.dip0.t-ipconnect.de [79.245.130.139])
	by mail02.iobjects.de (Postfix) with ESMTPSA id C593F41601A8
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 09:13:06 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 66B0311C0027
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 09:13:06 +0200 (CEST)
Subject: Re: why does df spin up disks?
To: linux-btrfs@vger.kernel.org
References: <201506291143.59911.russell@coker.com.au>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5590F002.1040209@googlemail.com>
Date: Mon, 29 Jun 2015 09:13:06 +0200
MIME-Version: 1.0
In-Reply-To: <201506291143.59911.russell@coker.com.au>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/15 03:43, Russell Coker wrote:
> When I have a mounted filesystem why doesn't the kernel store the amount of 
> free space?  Why does it need to spin up a disk that had been spun down?

Most likely because the inode has been evicted due to memory pressure. I can df my mostly-idle backup disk "most" of the time without it spinning up once it has been mounted & gone to sleep (just did!), but if there's been significant memory movement (or issuing drop_caches) on the box it will spin up again sometimes. This is not unique to btrfs; other filesystems - at least ext4 - do this too, even though they might manage their expiry behaviour differently.

Now, whether the root inode and whatever is required for a df *should* ever expire after mounting or stay pinned, well..you'd have to ask the vfs folks.

-h

