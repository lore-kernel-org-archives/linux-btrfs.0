From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: BTRFS thinks that a device is mounted
Date: Fri, 21 Oct 2011 10:10:12 +0000 (UTC)
Message-ID: <slrnja2h84.5ku.stephane.chazelas@spam.is.invalid>
References: <a46ac41f14ba1581cb554a0f26463859.squirrel@webmail01.edunet.gr>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-10-21, 00:39(+03), Nikos Voutsinas:
[...]
> ## Comment: Of course /dev/sdh is not mounted.
> mount |grep /dev/sdh
> root@lxc:~#
[...]

Note that mount(8) uses /etc/mtab to find out what is mounted.
And if that file is not a symlink to /proc/mounts, the
information is not necessarily correct.

You can also have a look at /proc/mounts directly.

-- 
Stephane

