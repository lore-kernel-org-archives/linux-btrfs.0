Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29163 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758119AbaHZOWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 10:22:41 -0400
Message-ID: <53FC982B.9090608@fb.com>
Date: Tue, 26 Aug 2014 10:22:35 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Btrfs-progs releases
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've just tagged btrfs-progs v3.16.  Like the last few releases, this
one was prepared by Dave Sterba, who has been wrangling btrfs-progs
patches for some time now.

Dave has asked to officially take over the btrfs-progs maintenance, and
I said yes before he could change his mind.  Everyone here is doing a
fantastic job improving btrfs-progs quality and usability, and making
Dave the btrfs progs maintainer will make sure these changes get
out on a regular basis.

Aside from more regular releases, very little will change.  I'm still
running the kernel releases, and I'm setting up more frequent pushes to
the kernel integration branch so we can more effectively manage our
patches for the next merge window.

While Dave is getting his kernel.org accounts setup, I'll keep pushing
his changes to my btrfs-progs git tree, and create tar balls in the
usual places.

Once his kernel.org trees are setup, we'll find a way to mirror his
master copy into my directories.

Thanks for your contributions everyone, please let us know if you have
any questions.

-chris
