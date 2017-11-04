Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:54228 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdKDHFx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 03:05:53 -0400
Date: Sat, 4 Nov 2017 08:05:50 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: updatedb does not index /home when /home is Btrfs
Message-ID: <20171104070550.lr5osyfz74axw5nl@angband.pl>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
 <20171104044916.4mpgaails24rqddz@angband.pl>
 <65c3c537-1e30-87ae-140a-b59bdd79a4dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <65c3c537-1e30-87ae-140a-b59bdd79a4dc@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 04, 2017 at 09:26:36AM +0300, Andrei Borzenkov wrote:
> 04.11.2017 07:49, Adam Borowski пишет:
> > On Fri, Nov 03, 2017 at 06:15:53PM -0600, Chris Murphy wrote:
> >> Ancient bug, still seems to be a bug.
> >> https://bugzilla.redhat.com/show_bug.cgi?id=906591
> >>
> >> The issue is that updatedb by default will not index bind mounts, but
> >> by default on Fedora and probably other distros, put /home on a
> >> subvolume and then mount that subvolume which is in effect a bind
> >> mount.
> >>
> >> There's a lot of early discussion in 2013 about it, but then it's
> >> dropped off the radar as nobody has any ideas how to fix this in
> >> mlocate.
> > 
> > I don't see how this would be a bug in btrfs.  The same happens if you
> > bind-mount /home (or individual homes), which is a valid and non-rare setup.
> 
> It is the problem *on* btrfs because - as opposed to normal bind mount -
> those mount points do *not* refer to the same content.

Neither do they refer to in a "normal" bind mount.

> As was commented in mentioned bug report:
> 
> mount -o subvol=root /dev/sdb1 /root
> mount -o subvol=foo /dev/sdb1 /root/foo
> mount -o subvol bar /dev/sdb1 /bar/bar
> 
> Both /root/foo and /root/bar, will be skipped even though they are not
> accessible via any other path (on mounted filesystem)

losetup -D
truncate -s 4G junk
losetup -f junk
mkfs.ext4 /dev/loop0
mkdir -p foo bar
mount /dev/loop0 foo
mkdir foo/bar
touch foo/fileA foo/bar/fileB
mount --bind foo/bar bar
umount foo

> It is a problem *of* btrfs because it does not offer any easy way to
> distinguish between subvolume mount and bind mount. If you are aware of
> one, please comment on mentioned bug report.

Well, subvolume mounts are indistinguishable from bind mounts because they
_are_ bind mounts.  You merely don't need to mount the "master" first.

The only way such a "master" mount is special is that, on most filesystems,
its root was accessible at least at some point (but it might no longer be,
thanks to chroot, pivot_root, etc).


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ Laws we want back: Poland, Dz.U. 1921 nr.30 poz.177 (also Dz.U. 
⣾⠁⢰⠒⠀⣿⡁ 1920 nr.11 poz.61): Art.2: An official, guilty of accepting a gift
⢿⡄⠘⠷⠚⠋⠀ or another material benefit, or a promise thereof, [in matters
⠈⠳⣄⠀⠀⠀⠀ relevant to duties], shall be punished by death by shooting.
