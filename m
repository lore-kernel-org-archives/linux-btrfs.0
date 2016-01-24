Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36634 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbcAXVRE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 16:17:04 -0500
Received: by mail-oi0-f50.google.com with SMTP id o124so76859979oia.3
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 13:17:03 -0800 (PST)
Date: Sun, 24 Jan 2016 14:17:01 -0700
From: Tom Hunt <tomdicksonhunt@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1
 rebalancing
Message-ID: <20160124211700.GF908@breitenfeld.lan>
References: <20160124175258.GD908@breitenfeld.lan>
 <CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
 <20160124205832.GE908@breitenfeld.lan>
 <CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My arrangement is two subvolumes, 'root' and 'home', directly under the root
subvolume. The 'root' subvolume is mounted on /, the 'home' subvolume on /home.
I've tried both pointing the find command at /, and mounting the root subvolume
on a mount directory and pointing it there. Neither show any file or directory
with inum 515.

On Sun, Jan 24, 2016 at 02:07:58PM -0700, Chris Murphy wrote:
> On Sun, Jan 24, 2016 at 1:58 PM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
> >> You delete the file and yet the scrub still says inode 515 exists and
> >> has an error? Or there are no errors, but then after copying the same
> >> file back to the volume, the problem reoccurs? Are there any snapshots
> >> or subvolumes? Because if there are any subvolumes/snapshots, each is
> >> its own fs tree with its own set of inodes. So an inode can be used
> >> more than once for different files so I wonder off hand if you haven't
> >> found the actual problematic file.
> >>
> >> Or possibly it's a directory, and not a file.
> >
> > There are no snapshots, but there are subvolumes. I did the same procedure on
> > the file at inode 515 in each subvolume, which was:
> >
> > # cp $file ~
> > # rm $file
> > # mv ~/$file {old_file_path}
> >
> > This concluded without any errors. After doing this, the inode number is
> > different, and 'find / -inum 515' no longer finds anything on either subvolume.
> > However, initiating a scrub after this still shows the error at ino 515.
> 
> Try pointing the find command at the mountpoint, rather than at a subvolume.
> 
> 
> -- 
> Chris Murphy

-- 
Tom Hunt
