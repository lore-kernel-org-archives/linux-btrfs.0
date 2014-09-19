Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43471 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757701AbaISRVe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 13:21:34 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49759 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XV1sD-003dXq-JI
	for linux-btrfs@vger.kernel.org; Fri, 19 Sep 2014 11:21:33 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help for creating a useful bugreport
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <541BF025.1030309@rwth-aachen.de>
Date: Fri, 19 Sep 2014 11:21:32 -0600
Message-Id: <8B585BCA-7FAB-4284-A6D6-BED5B5075ADD@colorremedies.com>
References: <541BF025.1030309@rwth-aachen.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 19, 2014, at 2:58 AM, Jakob Breier <Jakob.Breier@rwth-aachen.de> wrote:
> Unfortunately I don't have much to work with. Can you help me with extracting enough information to create a useful bugreport?

What storage device(s)?

Include results from
# btrfs check

And also a note whether you get different results with -s1, -s2, -s3 (how many backups superblocks you have depends on file system size so some of those might not work).

Since it won't mount you can't get fi df, but if you can provide that info so we know if, e.g. the metadata is single (by default on SSD) or DUP.

Was it created with btrfs-progs 3.16, and has it only been written to with kernel 3.16 or other kernels also?

If you can use btrfs-image per the wiki, and keep the image around, it might come in handy for a Btrfs developer.


> 
> Sep 19 10:16:18 localhost.localdomain kernel: parent transid verify failed on 46678016 wanted 4923 found 3306
> Sep 19 10:16:18 localhost.localdomain kernel: parent transid verify failed on 46678016 wanted 4923 found 3306

These messages come up often on the list. The notes written in disk-io.c say this:
 * we can't consider a given block up to date unless the transid of the
 * block matches the transid in the parent node's pointer.  This is how we
 * detect blocks that either didn't get written at all or got written
 * in the wrong place.

I don't know whether this definitely means hardware related problems of some sort, but it sounds suspiciously like that because blocks should get written in the correct place. Right? But they didn't.


> Sep 19 10:16:18 localhost.localdomain kernel: BTRFS: Failed to read block groups: -5

This came up in a recent thread "Problem with a filesystem". I'm not sure what it means.

Once you've taken the btrfs-image, and you're about ready to toss the file system it's worth trying these commands.

btrfs rescue super-recover -v
## if it fixes anything, don't continue, try to mount the fs
btrfs check --repair
## I'd try mounting even if it doesn't say it's repaired anything
btrfs check --repair --init-extent-tree
## Again try to mount the fs

And report kernel and user space messages.


Chris Murphy

