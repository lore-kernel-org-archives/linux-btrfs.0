Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58667 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965863AbdAIL2d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jan 2017 06:28:33 -0500
Date: Mon, 9 Jan 2017 12:28:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: luke@dashjr.org, luke-jr+git@utopios.org, jbacik@fb.com, dsterba@suse.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, clm@fb.com,
        linux-btrfs@vger.kernel.org, 1619918@bugs.launchpad.net
Subject: Re: [Regression 4.7-rc1] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20170109112815.GE12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 06, 2017 at 12:22:34PM -0500, Joseph Salisbury wrote:
> A kernel bug report was opened against Ubuntu [0].  This bug was fixed
> by the following commit in v4.7-rc1:
> 
> commit 4c63c2454eff996c5e27991221106eb511f7db38
> 
> Author: Luke Dashjr <luke@dashjr.org>
> Date:   Thu Oct 29 08:22:21 2015 +0000
> 
>     btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in
> btrfs_ioctl
> 
> 
> However, this commit introduced a new regression.  With this commit
> applied, "btrfs fi show" no longer works and the btrfs snapshot
> functionality breaks.

A plain 32bit kernel with 32bit userspace works fine. The bug seems to
be on a 64bit kernel with 32bit userspace and the CONFIG_COMPAT compiled
in. Strace does not show anything special:

stat64("subv1", 0xffc64fcc)             = -1 ENOENT (No such file or directory)
statfs64(".", 84, {f_type=BTRFS_SUPER_MAGIC, f_bsize=4096, f_blocks=5110784, f_bfree=4076143, f_bavail=4010951, f_files=0, f_ffree=0, f_fsid={val=[
4260464218, 2297804334]}, f_namelen=255, f_frsize=4096, f_flags=ST_VALID|ST_RELATIME}) = 0
stat64(".", {st_mode=S_IFDIR|0700, st_size=228, ...}) = 0
stat64(".", {st_mode=S_IFDIR|0700, st_size=228, ...}) = 0
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFDIR|0700, st_size=228, ...}) = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
write(1, "Create subvolume './subv1'\n", 27) = 27
ioctl(3, BTRFS_IOC_SUBVOL_CREATE, {fd=0, name="subv1"}) = -1 ENOTTY (Inappropriate ioctl for device)

The value of BTRFS_IOC_SUBVOL_CREATE is same on 32bit and 64bit kernels.
As it returns ENOTTY, the value is not recognized. A candidate function
is btrfs_compat_ioctl that checks for just the IOC32 numbers and returns
-ENOIOCTLCMD otherwise.

The callchain in fs/compat_ioctl.c:ioctl cheks for the specific callback
first, if it retunrs -ENOIOCTLCMD then goes to the normal ioctl
callback, so there's always a point we reach the handler of
BTRFS_IOC_SUBVOL_CREATE. So I don't see how it could happen.
