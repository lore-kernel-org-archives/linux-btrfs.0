Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57204 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3CZRe3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 13:34:29 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9032D7C04E0
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 11:34:28 -0600 (MDT)
Date: Tue, 26 Mar 2013 13:34:25 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Message-ID: <20130326173425.GA28030@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
 <20130326144855.GM1955@localhost.localdomain>
 <CAAr69zbBXr_c1_xroqueHG0Zobo8H94a2p6kB+GTsZVfkFCtGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAAr69zbBXr_c1_xroqueHG0Zobo8H94a2p6kB+GTsZVfkFCtGg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 09:59:57AM -0600, Szőts Ákos wrote:
> The error was just a silly "permission denied" one.
> 
> I uploaded the created image to www.morrohun.hu/temp/btrfs/btrfs.img
> SHA1: 90ee61e0724700495d26678d58dc229e04a04cc4
> Please, write me when you downloaded and I'll delete it.
> 
> I have the idea to run btrfsck from your tree on the file system
> again, but I won't touch the fs until you said so :).
> 

Ok you can go ahead and delete it, I just pulled it down, I'm restoring it and
then I'll see whats going on.  Thanks,

Josef
