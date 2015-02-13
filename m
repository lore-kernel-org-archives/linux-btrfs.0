Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbbBMRdD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 12:33:03 -0500
Date: Fri, 13 Feb 2015 18:33:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 23/24] Btrfs: sysfs: support seed devices in the sysfs
 layout
Message-ID: <20150213173300.GM8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
 <1423439785-10260-24-git-send-email-anand.jain@oracle.com>
 <20150211185259.GM28877@twin.jikos.cz>
 <54DC475C.4000002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54DC475C.4000002@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 02:25:32PM +0800, Anand Jain wrote:
> On 02/12/2015 02:52 AM, David Sterba wrote:
> > On Mon, Feb 09, 2015 at 07:56:24AM +0800, Anand Jain wrote:
> >> This adds an enhancement to show the seed fsid and devices.
> >>
> >> The way sprouting handles fs_devices:
> >>        clone seed fs_devices and add to the fs_uuids
> >>        mem copy seed fs_devices and assign to fs_devices->seed (move dev_list)
> >>        evacuate seed fs_devices contents to hold sprout fs devices contents
> >>
> >>    So to be inline with this fs_devices changes during seeding,
> >>    represent seed fsid under the sprout fsid, this is achieved
> >>    by using the kobject_move()
> >>
> >> eg: showing two levels of seeding.
> >
> > That's new to me, how does nested seeding work?
> 
>   I called below operation as nested seeding:
>      mark a sprout as seed, mount it, add a new sprout to it.
>      eg:
>       mkfs.btrfs /dev/sdz
>       btrfstune -S 1 /dev/sdz
>       mount /dev/sdz /btrfs
>       btrfs dev add /dev/sdy /btrfs
>       umount /btrfs
>       btrfstune -S 1 /dev/sdy
>       mount /dev/sdy /btrfs
>       btrfs dev add /dev/sdx /btrfs

While I'm not sure if seeding was originally expected to work on a
multi-device filesystem, it makes sense to me. But what I don't
understand here is the concept of 'nesting'.

Let's say we have device A, B and C, and a * denotes a seeding device.
Then we can start with a populated filesystem on device A.

Then mark it seeding, A*, all fine.

Add device B to A*, all writes are captured by B, fine.

Now, we make B seeding.

Mounting the filesystem from A* should not IMO see any device B* as all
changes were stored there, namely the superblock of A* is kept intact.

Mouting from B* should see both A* and B*. Here it may resemble some
nesting or chaining, if that's what you mean.

(Adding a device C to A*, B* would mean that just all writes are captured
by C, ie.  no difference compared to the respective situation for A*, B,
so I can stop the example here.)

I'm thinking about a representation of the possible relations between
the devices. Seems that the seeding hierarchy for one filesystem is
always linear, so it's ok to represent it by the filesystem UUID chain.

/sys/fs/btrfs/UUID1/UUID2/UUID3

What I still find unsatisfying is lack of any explicit naming attached
to the UUIDs. As we can use lots of types of UUID, saying that "if it
looks like an uuid if the main filesystem directory in sysfs, then it's
the seeding filesystem" is not the best we can come up with.

I don't have a final idea, but at least

/sys/fs/btrfs/UUID1/seeding/UUID2/seeding/UUID3

would look more friendly to the user and also more accssible to
scripting. We coud possibly add other files/dirs to the inserted
directory.


A sidenote: the nesting forms a tree structure so it's possible to do a
snapshotting on the filesystem level, very similar to what the LVM
snapshots do, but here we have to provide a new device manually to
capture the new writes and make sure that all the devices do not
disappear.
