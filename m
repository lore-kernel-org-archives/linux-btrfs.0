Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33461 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab3CZNBO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 09:01:14 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A73189A067F
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 07:01:14 -0600 (MDT)
Date: Tue, 26 Mar 2013 09:01:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel BUG on corrupted space cache under 3.7 and 3.8
Message-ID: <20130326130111.GI1955@localhost.localdomain>
References: <1420920.Yent3fKO0t@linux-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <1420920.Yent3fKO0t@linux-suse>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 05:37:35AM -0600, Szőts Ákos wrote:
> Dear list members,
> 
> Yesterday I was about to restart my computer and that's why I closed every 
> opened applications: three Eclipse instances, two other Java applications, 2 
> web browsers etc. It involved a lot of IO operations and before everything 
> could settle down my system became unresponsive.
> 
> I mean X & co. worked fine, but anything related to IO (opening a new screen, a 
> new application etc.) hung. My process explorer showed that nearly all of the 
> applications which were shutting down have very high IO, but in fact there 
> were no HDD head movement at all. I did a hard reset.
> 
> Today morning when I restarted Linux I got a kernel BUG from btrfs. I 
> successfully started a recovery Linux (with kernel 3.7) and when I tried to 
> mount this partition, the bug/panic appeared again. After I could rebuild the 
> space cache with clear_cache option and my system was fixed.
> 
> Since all this logs are written only onto screen, I made some photographs :), 
> and I uploaded them.
> 
> System parameters:
> - openSUSE 12.3, Kernel 3.8, x86_64
> - Linux linux-suse 3.8.0-5-desktop #1 SMP PREEMPT Tue Feb 26 20:55:05 UTC 2013 
> (db497a6) x86_64 x86_64 x86_64 GNU/Linux
> - Photos are made on Kernel 3.7
> - Default mount options: compress=lzo,space_cache
> - On 3.7, the problematic line: fs/btrfs/free-space-cache.c:1553
> - Photos location: www.morrohun.hu/temp/btrfs/[123].jpeg
> 
> If you need any other information, ask me :).
> 

Ok so I've just made a bunch of changes to btrfs-image so I can capture your
tree log and free space cache so I can reproduce exactly this issue :).  Can you
clone this tree

git://github.com/josefbacik/btrfs-progs.git

and then build and run

btrfs-image -c9 /dev/whatever blah.img

and upload blah.img somewhere so I can pull it down?  If you've already fixed
the file system so it mounts then I don't need the image, I need it only if it
is still panicing.  So if you have already fixed it then still please clone that
tree and next time it happens capture the fs image if you could so I can
reproduce and fix the problem.  Thanks,

Josef
