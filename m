Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:41136 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbdKFA1S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Nov 2017 19:27:18 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:56400)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eBVFy-0006pz-PC
        for linux-btrfs@vger.kernel.org; Mon, 06 Nov 2017 00:27:14 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eBVFs-0007ym-Er
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 00:27:08 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <23039.44123.933173.628778@tree.ty.sabi.co.uk>
Date: Mon, 6 Nov 2017 00:27:07 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fixed subject: updatedb does not index separately mounted btrfs subvolumes
In-Reply-To: <pan$94157$844c1b67$c8d5af52$b34db269@cox.net>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
        <pan$94157$844c1b67$c8d5af52$b34db269@cox.net>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> The issue is that updatedb by default will not index bind
>> mounts, but by default on Fedora and probably other distros,
>> put /home on a subvolume and then mount that subvolume which
>> is in effect a bind mount.

> <gripe-mode: inaccurate subject lines>

> So the issue isn't /home being btrfs (as you said in the
> subject), but rather, it's /home being an explicitly mounted
> subvolume, since btrfs uses bind-mounts internally for
> subvolume mounts.

That to me seems like rather improper terminology and notes, and
I would consider these to be more appropriate:

* There are entities known as "root directories", and their main
  property is that all inodes reachable from one in the same
  filesystem have the same "device id".
* Each "filesystem" has at least one, and a Btrfs "volume" has
  one for every "subvolume", including the "top subvolume".
* A "root directory" can be "mounted" on a "mount point"
  directory of another "filesystem", which allows navigating
  from one filesystem to another.
* A "mounted" root directory can be identified by the device id
  of '.' being different from that of '..'.
* In Linux a "root directory" can be "mounted" onto several
  "mount point" directories at the same time.
* In Linux a "bind" operation is not a "mount" operation, it is
  in effect a kind of temporary "hard link", one that makes a
  directory aliased to a "bind point" directory.

Looking at this:

  tree#  tail -3 /proc/mounts                                                                                                                                            
  /dev/mapper/sda7 /fs/sda7 btrfs rw,nodiratime,relatime,nossd,nospace_cache,user_subvol_rm_allowed,subvolid=5,subvol=/ 0 0
  /dev/mapper/sda7 /fs/sda7/bind btrfs rw,nodiratime,relatime,nossd,nospace_cache,user_subvol_rm_allowed,subvolid=431,subvol=/= 0 0
  /dev/mapper/sda7 /fs/sda7/bind-tmp btrfs rw,nodiratime,relatime,nossd,nospace_cache,user_subvol_rm_allowed,subvolid=431,subvol=/=/tmp 0 0

  tree#  stat --format "%3D %6i %N" {,/fs,/fs/sda7}/{.,..} /fs/sda7/{=,=/subvol,=/subvol/dir,=/tmp,bind,bind-tmp}/{.,..} 
  806      2 ‘/.’
  806      2 ‘/..’
   23  36176 ‘/fs/.’
  806      2 ‘/fs/..’
   26    256 ‘/fs/sda7/.’
   23  36176 ‘/fs/sda7/..’
   27    256 ‘/fs/sda7/=/.’
   26    256 ‘/fs/sda7/=/..’
   2b    256 ‘/fs/sda7/=/subvol/.’
   27    256 ‘/fs/sda7/=/subvol/..’
   2b    258 ‘/fs/sda7/=/subvol/dir/.’
   2b    256 ‘/fs/sda7/=/subvol/dir/..’
   27 344618 ‘/fs/sda7/=/tmp/.’
   27    256 ‘/fs/sda7/=/tmp/..’
   27    256 ‘/fs/sda7/bind/.’
   26    256 ‘/fs/sda7/bind/..’
   27 344618 ‘/fs/sda7/bind-tmp/.’
   26    256 ‘/fs/sda7/bind-tmp/..’

It shows that subvolume root directories are "mount points" and
not "bind points" (note that ‘/fs/sda7/=/subvol’ is not
explicitly mounted, yet its '.' and '..' have different device
ids), and that "bind points" appear as if they were ordinary
directories (an unwise decision I suspect).

Many tools for UNIX-like systems don't cross "mount point"
directories (or follow symbolic links), by default or with an
option, but will cross "bind point" directories as they look
like ordinary directories.

For 'mlocate' the "bind point" directories are a special case,
handled by looking up every directory examined in the list of
"bind point" directories, as per line 381 here:

https://pagure.io/mlocate/blob/master/f/src/bind-mount.c#_381
