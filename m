From: Troy Ablan <tablan@gmail.com>
Subject: Re: panic during rebalance, and now upon mount
Date: Sun, 31 Jan 2010 12:33:44 -0700
Message-ID: <4B65DB18.60309@gmail.com>
References: <4B63CC39.1020505@gmail.com>	 <3d0408631001300409i13326d13vac10a3f639f6db92@mail.gmail.com>	 <4B646D08.1020307@gmail.com>	 <3d0408631001301800y5de8a412w1d29bdb5e5e79f84@mail.gmail.com>	 <4B6556C9.7060809@gmail.com> <3d0408631001310434g35b1fa4cp8a42068ef5fa5a34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408631001310434g35b1fa4cp8a42068ef5fa5a34@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan, Zheng wrote:
> Please try the patch attached below. It should solve the bug during
> mounting
> that fs. But I don't know why there are so many link count errors in that fs.
> How old is that fs? what was that fs used for?
>
> Thank you very much.
> Yan, Zheng
>
>   
Good, so far.  Thanks!

The filesystem is less than 2 weeks old, created and managed exclusively
with the unstable tools Btrfs v0.19-4-gab8fb4c-dirty

I created the filesystem -d raid1 -m raid1.

There are 14 dm-crypt mappings corresponding to 14 partitions on 14
drives.  There's one filesystem made up from these devices with about 14
TB of space (a mixture of devices ranging from 500GB to 2TB)

The filesystem is used for incremental backup from remote computers
using rsync.

The filesystem tree is as follows

/
/machine1 <- normal directory
/machine1/machine1 <- a subvolume
/machine1/machine1-20100120-1220 <- a snapshot of the subvolume above
...
/machine1/machine1-20100131-1220 <- more snapshots of the subvolume above
/machine2 <- normal directory
/machine2/machine1 <- a subvolume
/machine2/machine2-20100120-1020 <- a snapshot of the subvolume above
...
/machine2/machine2-20100131-1020 <- more snapshots of the subvolume above
...

The files are backed up with `rsync -aH --inplace` onto the subvolume
for each machine.

The only oddness I can think of is that during initial testing of this
filesystem, I yanked a drive physically from the machine while it was
writing.  btrfs seemed to continue to try to write to the inaccessible
device, and indeed, btrfs-show showed the used space on the missing
drive increasing over time.  Also, I was unable to remove the drive from
the volume (ioctl returned -1), so it was in this state until I rebooted
a couple hours later.   I then did a btrfs-vol -r missing on the drive,
and then added it back in as a new device.  I did btrfs-vol -b which
succeeded once.   After adding more drives, I did btrfs-vol -b again,
and that left me in the state where this thread began.

As I understand it, a btrfs-vol -b is currently one of the only ways to
reduplicate unmirrored chunks after a drive failure. (aside from
rewriting the data or removing and readding devices).  Is my
understanding correct?

Thanks

-- 
Troy
