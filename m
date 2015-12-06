Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53923 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbbLFOfG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Dec 2015 09:35:06 -0500
Subject: Re: attacking btrfs filesystems via UUID collisions?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <20151204120529.37E47D5A28@emkei.cz>
 <20151204130758.GR8775@carfax.org.uk>
 <1449286104.18841.14.camel@scientia.net>
 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
 <1449366680.3183.37.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56644785.4090702@gmx.com>
Date: Sun, 6 Dec 2015 22:34:45 +0800
MIME-Version: 1.0
In-Reply-To: <1449366680.3183.37.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/06/2015 09:51 AM, Christoph Anton Mitterer wrote:
> On Sat, 2015-12-05 at 13:19 +0000, Duncan wrote:
>> The problem with btrfs is that because (unlike traditional
>> filesystems)
>> it's multi-device, it needs some way to identify what devices belong
>> to a
>> particular filesystem.
> Sure, but that applies to lvm, or MD as well... and I wouldn't know of
> any random corruption issues there.

Not sure about LVM/MD, but they should suffer the same UUID conflict 
problem.

The only idea I have can only enhance the behavior, but never fix it.
For example, if found multiple btrfs devices with same devid, just 
refuse to mount.
And for already mounted btrfs, ignore any duplicated fsid/devid.

The problem can get even tricky for case like device missing for a while 
and appear again case.


But just as you mentioned, it *IS* a real problem, and we should need to 
enhance it.

>
>
>> And UUID is, by definition and expansion, Universally Unique ID.
> Nitpicking doesn't help here,... reality is they're not,.. either by
> people doing stuff like dd, other forms of clones, LVM, etc. ... or as
> I've described maliciously.
>
>
>> Btrfs
>> simply depends on it being what it says on the the tin, universally
>> unique, to ID the components of the filesystem and assemble them
>> correctly.
> Admittedly, I'm not an expert to the internals of btrfs, but it seems
> other multi-device containers can handle UUID duplicates fine, or at
> least so that you don't get any data corruption (or leaks).

I'd like to see how LVM/DM behaves first, at least as a reference if 
they are really so safe.
For example, I have a whole disk as the following configuration:

0         10G         20G
| test_lv |           |
----------------
|  test_vg     |
-----------------------
|       test_pv       |
-----------------------
|    /dev/sdb         |
-----------------------

If I did a dd copy of /dev/sdb to /dev/sdc,
what will pv/vg/lv rescan show if test_pv/vg/lv is already active?
And what will rescan show if they are not active? Or after a reboot?

>
> This is a showstopper - maybe not under lab conditions but surely under
> real world scenarios.
> I'm actually quite surprised that no-one else didn't complain about
> that before, given how long btrfs exists.
>
>
>> Besides dd, etc, LVM snapshots are another case where this goes
>> screwy.
>> If the UUID isn't UUID, do a btrfs device scan (which udev normally
>> does
>> by default these days) so the duplicate UUID is detected, and btrfs
>> *WILL* eventually start trying to write to all the "newly added"
>> devices
>> that scan found, identified by their Universally Unique IDs, aka
>> UUIDs.
>> It's not a matter of if, but when.
> Well.. as I said... quite scary, with respect to both, accidental and
> malicious cases of duplicate UUIDs.
>
>
>> And the UUID is embedded so deeply within the filesystem and its
>> operations, as an inextricable part of the metadata (thus avoiding
>> the
>> problem reiserfs had where a reiserfs stored in a loopback file on a
>> reiserfs, would screw up reiserfsck, on btrfs, the loopback file
>> would
>> have a different UUID and thus couldn't be mixed up), that changing
>> the
>> UUID is not the simple operation of changing a few bytes in the
>> superblock
>> that it is on other filesystems, which is why there's now a tool to
>> go
>> thru all those metadata entries and change it.
> I don't think that this design is per se bad and prevents the kernel to
> handle such situations gracefully.
>
> I would expect that in addition to the fs UUID, it needs a form of
> device ID... so why not simply ignoring any new device for which there
> already is a matching fs UUID and device ID, unless the respective tool
> (mount, btrfs, etc.) is explicitly told so via some
> device=/dev/sda,/dev/sdb option.

IIRC, there were some btrfs-progs patches for such behavior, not sure 
about kernel part though.
But at least an interesting method to solve the problem.
(Better than just rejecting mounting any)
>
> If that means that less things work out of the box (in the sense of
> "auto-assembly") well than this is simply necessary.
> data security and consistency is definitely much more important than
> any fancy auto-magic.

Can't agree any more.
Especially when auto leads to wrong behavior (Like kernel version based 
probing).



And after all, this topic makes me remember the bugreport of fuzzed (but 
csum recalculated) images.
I used to ignore them and I think that wouldn't happen.

But the reporter is right, it's a btrfs security problem, and now I'm 
super happy to see such report.
As it's easy to fix, I can always submit some patches if there is no 
other guy faster than me. :)

So for this one, as long as we find a good behavior to solve it, it 
won't be a big thing.

Thanks,
Qu
>
>
>
>> So an aware btrfs admin simply takes pains to avoid triggering a
>> btrfs
>> device scan at the wrong time, and to immediately hide their LVM
>> snapshots, immediately unplug their directly dd-ed devices, etc, and
>> thus
>> doesn't have to deal with the filesystem corruption that'd be a when
>> not
>> if, if they didn't take such precautions with their dupped UUIDs that
>> actually aren't as UUID as the name suggests...
> a) People shouldn't need to do days of study to be able to use btrfs
> securely.

> Of course it's more advanced and not everything can be
> simplified in a way so that users don't need to know anything (e.g. all
> the well-known effects of CoW)... but when the point is reached where
> security and data integrity is threatened, there's definitely a hard
> border that mustn't be crossed.
>
> b) Given how complex software is, I doubt that it's easily possible,
> even for the aware admin, to really prevent all situations that can
> lead to such situations.
> Not to talk about about any attack-scenarios.
>
>
>
>> And as your followup suggests in a security context, they consider
>> masking out their UUIDs before posting them, as well, tho most kernel
>> hackers generally consider unsupervised physical access to be game-
>> over,
>> security-wise.
> Do they? I rather thought many of them had a rather practical and real-
> world-situations-based POV.
>
>> (After all, in that case there's often little or nothing
>> preventing a reboot to that USB stick, if desired, or simply yanking
>> the
>> devices and duping them or plugging them in elsewhere, if the BIOS is
>> password protected, with the only thing standing in the way at that
>> point
>> being possible device encryption.)
> There's hardware which would, when it detects physicals intrusion (like
> yanking) lock up itself (securely clearing the memory, disconnecting
> itself from other nodes, which may be compromised as well, when the
> filesystem on the attacked node would go crazy.
>
> You have things like ATMs, which are physically usually quite well
> secured, but which do have rather easily accessible maintenance ports.
> All of us have seen such embedded devices rebooting themselves, where
> you see kernel messages.
> That's the point where an attacker could easily get the btrfs UUID:
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.2.0-1-amd64
> root=UUID=bd1ea5a0-9bba-11e5-82fa-502690aa641f
>
> If you can attack such devices already by just having access to a USB
> port... then holly sh**...
>
>
>> The only real
>> alternative if
>> you don't like it is using a different filesystem.
> As I've said, I don't have a problem with UUIDs... I just can't quite
> believe that btrfs and the userland cannot be modified so that it
> handles such cases gracefully.
>
> If not, than, to be quite honest, that would be really a major
> showstopper for many usage areas.
> And I'm not talking about ATMs (or any other embedded devices where
> people may have non-supervides access - e.g. TVs in a mall,
> entertainment systems in planes) but also the normal desktops/laptops
> where colleagues, fellow students, etc. may want to play some "prank".
>
>
> Cheers,
> Chris.
>
