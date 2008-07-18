From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsctl -A not returning useful information
Date: Fri, 18 Jul 2008 16:33:07 -0400
Message-ID: <1216413187.6932.73.camel@think.oraclecorp.com>
References: <3da3b5b40807181028p42e1a15di938dc62cccbc766c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40807181028p42e1a15di938dc62cccbc766c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-18 at 20:28 +0300, Ahmed Kamal wrote:
> [root@btrfs progs-unstable]# btrfsctl -A /dev/sdb
> ioctl returns 0
> [root@btrfs progs-unstable]# btrfsctl -A /dev/sdc
> ioctl returns 0
> 
> 
> /dev/sdb has a btrfs, while /dev/sdc is blank. What's that output
> supposed to mean ? Is it a bug ?

It isn't an error to scan a partition that doesn't have btrfs on it.
btrfsctl -A is just a single shot scan of a single device.  It is meant
for use by programs like udev to scan storage.

It think what you want is btrfs-show.

-chris


