From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: btrfs wishlist
Date: Tue, 1 Mar 2011 11:09:56 -0800
Message-ID: <AANLkTimdmnWvVQ7LuqpOkvRpmXDibcKXDL86a8DHoWvc@mail.gmail.com>
References: <28499638.308.1299004542529.JavaMail.root@zimbra>
	<1299004651-sup-1713@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299004651-sup-1713@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 1, 2011 at 10:39 AM, Chris Mason <chris.mason@oracle.com> wrote:
> Excerpts from Roy Sigurd Karlsbakk's message of 2011-03-01 13:35:42 -0500:
>
>> - Pool-like management with multiple RAIDs/mirrors (VDEVs)
>
> We have a pool of drives now....I'm not sure exactly what the vdevs are.

This functionality is in btrfs already, but it's using different
terminology and configuration methods.

In ZFS, the lowest level in the storage stack is the physical block device.

You group these block devices together into a virtual device (aka
vdev).  The possible vdevs are:
  - single disk vdev, with no redundancy
  - mirror vdev, with any number of devices (n-way mirroring)
  - raidz1 vdev, single-parity redundancy
  - raidz2 vdev, dual-parity redundancy
  - raidz3 vdev, triple-party redundancy
  - log vdev, separate device for "journaling", or as a write cache
  - cache vdev, separate device that acts as a read cache

A ZFS pool is made up of a collection of the vdevs.

For example, a simple, non-redundant pool setup for a laptop would be:
  zpool create laptoppool da0

To create a pool with a dual-parity vdev using 8 disks:
  zpool create mypool raidz2 da0 da1 da2 da3 da4 da5 da6 da7

To later add to the existing pool:
  zpool add mypool raidz2 da8 da9 da10 da11 da12 da13 da14 da15

Later, you create your ZFS filesystems ontop of the pool.

With btrfs, you setup the redundancy and the filesystem all in one
shot, thus combining the "vdev" with the "pool" (aka filesystem).

ZFS has better separation of the different layers (device, pool,
filesystem), and better tools for working with them (zpool / zfs) but
similar functionality is (or at least appears to be) in btrfs already.

Using device mapper / md underneath btrfs also gives you a similar setup to ZFS.

-- 
Freddie Cash
fjwcash@gmail.com
