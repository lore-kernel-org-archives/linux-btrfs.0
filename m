Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:45698 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3GARS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 13:18:29 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8AD277C035B
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 11:18:28 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>, Josef Bacik <jbacik@fusionio.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130701161002.GO10265@lenny.home.zabbo.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130701125435.GE4288@localhost.localdomain>
 <20130701161002.GO10265@lenny.home.zabbo.net>
Message-ID: <20130701171826.14981.597@localhost.localdomain>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Date: Mon, 1 Jul 2013 13:18:26 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Zach Brown (2013-07-01 12:10:02)
> > > code.  It's all lightly tested with xfstests but it wouldn't surprise
> > > me if I missed something so review is appreciated.
> 
> *mmm, hmmm*
> 
> > One of these patches is making new entries not show up in readdir.  This was
> > discovered while running stress.sh overnight, it complained about files not
> > matching but when they were checked the files matched.  Dropping the entire
> > series made stress.sh run fine.  So I'm dropping these for the next merge window
> > but I'll dig into it and try and figure out what was causing the problem.
> 
> Nerts.  It's got to be the delayed inode stuff.
> 
> Maybe it's some unlink/recreate pattern?  Is this a thing that stress.sh
> does?  (Where's stress.sh live?)

It's an old namesys tool, I've copied it here:

http://masoncoding.com/mason/tools/stress.sh

My command line:

stress.sh -n 50 -s -c /build/linux /mnt

Basically its:

1) Make a list of all files in /build/linux and their md5sums
2) Start 50 procs
3) Each proc copies /build/linux into /mnt/stress/proc_num/
4) Each proc compares the md5sums of its private copy with the original
master
5) Each proc deletes the private copy
6) Repeat steps 2-5 forever.

The most likely cause of the bug I'm seeing is readdir not finding new
files.

-chris

