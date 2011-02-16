From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: Excluding a device from storing snapshot data?
Date: Wed, 16 Feb 2011 10:36:08 +0000
Message-ID: <1297852568.4315.18.camel@cheyenne>
References: <AANLkTik1u=zWwqMXT7tAqkwhY5Z0U2k8YjQBJx_VjSXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik1u=zWwqMXT7tAqkwhY5Z0U2k8YjQBJx_VjSXg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2011-02-15 at 23:58 +0100, Bert Wesarg wrote:
> Hi all,
> 
> I'm currently envision a backup setup for my laptop which has a SSD. I
> would like to use an external HDD und span a raid1 over these two
> devices and also creating snapshots. What I would like to prevent, is
> that these snapshots take storage space on the SSD, because SSD
> storage is precious, while this isn't true for the external HDD. So I
> would need to exclude the SSD device to store snapshot data, or to be
> more precise, to store only one specific subvolume. Which can
> obviously be changing, if I need to restore a previous snapshot. Is
> this currently or actually possible?
> 
I would say that it is not "actually" possible... because when you
create a snapshot, no actual data is generated, the snapshot is
initially only metadata pointing to the same blocks on disk as the
original data...  Changes being written in a new location so over time
retaining the snapshot will have a storage overhead, but the process of
creating the snapshot doesn't write anything, and any new data written
is part of the real data, not the snapshot.

Perhaps a more pertinent question is "Are there any plans to implement
any kind of Hierarchical Storage Management in BTRFS"... I'm not sure
how complex it actually would be to implement, but having some
understanding of the speed of devices and the frequency of access to
particular blocks could allow the data to be re-balanced in favour of
placing frequently accessed blocks on faster storage.

Anyone have a comment on this?

> Thanks.
> 
> Bert




