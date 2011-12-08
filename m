From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 8 Dec 2011 16:27:46 +0000 (UTC)
Message-ID: <slrnje1pc2.lfa.stephane.chazelas@spam.is.invalid>
References: <22fa7cb1-728a-4a3d-a51b-3ff54053380e@mail.placs.net>
 <4EE0DC86.9080005@cfl.rr.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-12-08, 10:49(-05), Phillip Susi:
> On 12/7/2011 1:49 PM, BJ Quinn wrote:
>> What I need isn't really an equivalent "zfs send" -- my script can do
>> that. As I remember, zfs send was pretty slow too in a scenario like
>> this. What I need is to be able to clone a btrfs array somehow -- dd
>> would be nice, but as I said I end up with the identical UUID
>> problem. Is there a way to change the UUID of an array?
>
> No, btrfs send is exactly what you need.  Using dd is slow because it 
> copies unused blocks, and requires the source fs be unmounted.
[...]

Not necessarily, you can snapshot them (as in the method I
suggested). If your FS is already on a device mapper device, you
can even get away with not unmounting it (freeze, reload the
device mapper table with a snapshot-origin one and thaw).

> and the destination be an empty partition.  rsync is slow
> because it can't take advantage of the btrfs tree to quickly
> locate the files (or parts of them) that have changed.  A
> btrfs send would solve all of these issues.
[...]

When you want to clone a FS using a similar device or set of
devices, a tool like clone2fs or ntfsclone that copies only the
used sectors across sequentially would probably be a lot more
efficient as it copies the data at the max speed of the drive,
seeking as little as possible.

-- 
Stephane

