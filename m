From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: Removing snapshots
Date: Wed, 14 Jul 2010 12:15:48 -0700
Message-ID: <4C3E0CE4.4020309@noir.com>
References: <BB8A38D2-8990-4B87-8A4E-E9BD530D340F@noir.com> 	<AANLkTik359_CjeNj4dS_LMOEMdP3AMXR9WUiJP4dMuLY@mail.gmail.com> <AANLkTilAOzycyOU2PlIjDJqmocPOWgmpPZVFWTx9cMUG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilAOzycyOU2PlIjDJqmocPOWgmpPZVFWTx9cMUG@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  Here's what I'm getting on ubuntu-10.04 with standard tools, 
(/sbin/btrfsctl), and freshly built tools, (/usr/local/bin/btrfsctl).

Are we sure that the btrfs kernel module in this release is supporting 
the right ioctls?

--rich

rich@diamonds> pwd
/home/rich
rich@diamonds> mount | grep /home
/dev/sda7 on /home type btrfs (rw,noatime)
rich@diamonds> /sbin/btrfsctl -s snaptest /home
operation complete
Btrfs Btrfs v0.19
rich@diamonds> ls -lasd snaptest
4 drwxr-xr-x 1 root root 52 2010-06-21 16:13 snaptest
rich@diamonds> /sbin/btrfsctl
no valid commands given
usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]
                 [-r size] [-A device] [-a] [-c]
         -d filename: defragments one file
         -d directory: defragments the entire Btree
         -s snap_name dir: creates a new snapshot of dir
         -S subvol_name dir: creates a new subvolume
         -r [+-]size[gkm]: resize the FS by size amount
         -A device: scans the device file for a Btrfs filesystem
         -a: scans all devices for Btrfs filesystems
         -c: forces a single FS sync
Btrfs Btrfs v0.19
rich@diamonds> /usr/local/bin/btrfsctl
no valid commands given
usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]
                 [-r size] [-A device] [-a] [-c] [-D dir .]
         -d filename: defragments one file
         -d directory: defragments the entire Btree
         -s snap_name dir: creates a new snapshot of dir
         -S subvol_name dir: creates a new subvolume
         -r [+-]size[gkm]: resize the FS by size amount
         -A device: scans the device file for a Btrfs filesystem
         -a: scans all devices for Btrfs filesystems
         -c: forces a single FS sync
         -D: delete snapshot
         -m [tree id] directory: set the default mounted subvolume to 
the [tree id] or the directory
Btrfs v0.19-16-g075587c
rich@diamonds> /usr/local/bin/btrfsctl -D snaptest
ioctl:: Operation not permitted
rich@diamonds> sudo /usr/local/bin/btrfsctl -D snaptest
ioctl:: No such file or directory
rich@diamonds> sudo /usr/local/bin/btrfsctl -D snaptest /home
ioctl:: No such file or directory
rich@diamonds> sudo /usr/local/bin/btrfsctl -D /home snaptest
ioctl:: Invalid argument

