Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55464 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3EJPIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 11:08:11 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8C3BC7C067C
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 09:08:10 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1367874680-9502-1-git-send-email-dsterba@suse.cz>
CC: David Sterba <dsterba@suse.cz>
References: <1367874680-9502-1-git-send-email-dsterba@suse.cz>
Message-ID: <20130510150808.12615.77419@localhost.localdomain>
Subject: Re: [PATCH] btrfs-progs: image: handle superblocks correctly on fs with big
 blocks
Date: Fri, 10 May 2013 11:08:08 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-05-06 17:11:20)
> Superblock is always 4k, but metadata blocks may be larger. We have to
> use the appropriate block size when doing checksums, otherwise they're
> wrong.

The size coming in from the md should be correct.  See this commit from
my integration branch

https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?h=integration&id=9c821327408803229e93a788e032e8e9caf11686

-chris
