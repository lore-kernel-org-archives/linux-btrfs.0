From: Chris Ball <cjb@laptop.org>
Subject: Re: zero-length files in snapshots
Date: Thu, 11 Feb 2010 22:11:59 -0500
Message-ID: <m38wazywow.fsf@pullcord.laptop.org>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
	(Nickolai Zeldovich's message of "Thu, 11 Feb 2010 20:49:42 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > I often get zero-length files in btrfs snapshots (when the
   > original files were not zero-length).  The shell script below
   > reproduces this problem on two Ubuntu machines, with Ubuntu
   > kernels 2.6.31-17.54 and 2.6.32-12.17.  Is there some mistaken
   > assumption I'm making here in terms of how btrfsctl works?
   > [..]
   > 
   > echo x1 > /mnt/x/d/foo.txt || exit 2
   > btrfsctl -s /mnt/x/snap /mnt/x/d

You're just missing a sync/fsync() between these two lines.

We argued on IRC a while ago about whether this is a sensible default;
cmason wants the no-sync version of snapshot creation to be available,
but was amenable to the idea of changing the default to be sync before
snapshot, since it was pointed out that no-one other than him had
understood we were supposed to be running sync first.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
