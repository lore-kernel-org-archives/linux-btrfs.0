Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:55150 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753734AbdKAMBu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 08:01:50 -0400
Received: by mail-io0-f180.google.com with SMTP id e89so5435872ioi.11
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 05:01:50 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <1509467017.1662.37.camel@gmail.com>
 <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
 <1509480384.1662.84.camel@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ea097624-d485-9423-387f-3c9427508883@gmail.com>
Date: Wed, 1 Nov 2017 08:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <1509480384.1662.84.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 16:06, ST wrote:
> Thank you very much for such an informative response!
> 
> 
> On Tue, 2017-10-31 at 13:45 -0400, Austin S. Hemmelgarn wrote:
>> On 2017-10-31 12:23, ST wrote:
>>> Hello,
>>>
>>> I've recently learned about btrfs and consider to utilize for my needs.
>>> I have several questions in this regard:
>>>
>>> I manage a dedicated server remotely and have some sort of script that
>>> installs an OS from several images. There I can define partitions and
>>> their FSs.
>>>
>>> 1. By default the script provides a small separate partition for /boot
>>> with ext3. Does it have any advantages or can I simply have /boot
>>> within / all on btrfs? (Note: the OS is Debian9)
>> It depends on the boot loader.  I think Debian 9's version of GRUB has
>> no issue with BTRFS, but see the response below to your question on
>> subvolumes for the one caveat.
>>>
>>> 2. as for the / I get ca. following written to /etc/fstab:
>>> UUID=blah_blah /dev/sda3 / btrfs ...
>>> So top-level volume is populated after initial installation with the
>>> main filesystem dir-structure (/bin /usr /home, etc..). As per btrfs
>>> wiki I would like top-level volume to have only subvolumes (at least,
>>> the one mounted as /) and snapshots. I can make a snapshot of the
>>> top-level volume with / structure, but how can get rid of all the
>>> directories within top-lvl volume and keep only the subvolume
>>> containing / (and later snapshots), unmount it and then mount the
>>> snapshot that I took? rm -rf / - is not a good idea...
>> There are three approaches to doing this, from a live environment, from
>> single user mode running with init=/bin/bash, or from systemd emergency
>> mode.  Doing it from a live environment is much safer overall, even if
>> it does take a bit longer.  I'm listing the last two methods here only
>> for completeness, and I very much suggest that you use the first (do it
>> from a live environment).
>>
>> Regardless of which method you use, if you don't have a separate boot
>> partition, you will have to create a symlink called /boot outside the
>> subvolume, pointing at the boot directory inside the subvolume, or
>> change the boot loader to look at the new location for /boot.
>>
>>   From a live environment, it's pretty simple overall, though it's much
>> easier if your live environment matches your distribution:
>> 1. Create the snapshot of the root, naming it what you want the
>> subvolume to be called (I usually just call it root, SUSE and Ubuntu
>> call it @, others may have different conventions).
>> 2. Delete everything except the snapshot you just created.  The safest
>> way to do this is to explicitly list each individual top-level directory
>> to delete.
>> 3. Use `btrfs subvolume list` to figure out the subvolume ID for the
>> subvolume you just created, and then set that as the default subvolume
>> with `btrfs subvolume set-default /path SUBVOLID`.
> 
> Do I need to chroot into old_root before doing set-default? Otherwise it
> will attempt to set in the live environment, will it not?
The `subvolume set-default` command operates on a filesystem, not an 
environment, since the default subvolume is stored in the filesystem 
itself (it would be kind of pointless otherwise).  The `/path` above 
should be replaced with where you have the filesystem mounted, but it 
doesn't matter what your environment is when you call it (as long as the 
filesystem is mounted of course).
> 
> Also another questions in this regard - I tried to "set-default" and
> then reboot and it worked nice - I landed indeed in the snapshot, not
> top-level volume. However /etc/fstab didn't change and actually showed
> that top-level volume should have been mounted instead. It seems that
> "set-default" has higher precedence than fstab...
> 1. is it true?
> 2. how do they actually interact?
> 3. such a discrepancy disturbs me, so how should I tune fstab to reflect
> the change? Or maybe I should not?
The default subvolume is what gets mounted if you don't specify a 
subvolume to mount.  On a newly created filesystem, it's subvolume ID 5, 
which is the top-level of the filesystem itself.  Debian does not 
specify a subvo9lume in /etc/fstab during the installation, so setting 
the default subvolume will control what gets mounted.  If you were to 
add a 'subvolume=' or 'subvolid=' mount option to /etc/fstab for that 
filesystem, that would override the default subvolume.

The reason I say to set the default subvolume instead of editing 
/etc/fstab is a pretty simple one though.  If you edit /etc/fstab and 
don't set the default subvolume, you will need to mess around with the 
bootloader configuration (and possibly rebuild the initramfs) to make 
the system bootable again, whereas by setting the default subvolume, the 
system will just boot as-is without needing any other configuration changes.
> 
>>    Once you do this,
>> you will need to specify subvolid=5 in the mount options to get the real
>> top-level subvolume.
>> 4. Reboot.
>>
>> For single user mode (check further down for what to do with systemd,
>> also note that this may brick your system if you get it wrong):
>> 1. When booting up the system, stop the bootloader and add
>> 'init=/bin/bash' to the kernel command line before booting.
>> 2. When you get a shell prompt, create the snapshot, just like above.
>> 3. Run the following:
>> 'cd /path ; mkdir old_root ; pivot_root . old_root ; chroot . /bin/bash'
>> 3. You're now running inside the new subvolume, and the old root
>> filesystem is mounted at /old_root.  From here, just follow steps 2 to 4
>> from the live environment method.
>>
>> For doing it from emergency mode, things are a bit more complicated:
>> 1. Create the snapshot of the root, just like above.
>> 2. Make sure the only services running are udev and systemd-journald.
>> 3. Run `systemctl switch-root` with the path to the subvolume you just
>> created.
>> 4. You're now running inside the new root, systemd _may_ try to go all
>> the way to a full boot now.
>> 5. Mount the root filesystem somewhere, and follow steps 2 through 4 of
>> the live environment method.
>>>
>>> 3. in my current ext4-based setup I have two servers while one syncs
>>> files of certain dir to the other using lsyncd (which launches rsync on
>>> inotify events). As far as I have understood it is more efficient to use
>>> btrfs send/receive (over ssh) than rsync (over ssh) to sync two boxes.
>>> Do you think it would be possible to make lsyncd to use btrfs for
>>> syncing instead of rsync? I.e. can btrfs work with inotify events? Did
>>> somebody try it already?
>> BTRFS send/receive needs a read-only snapshot to send from.  This means
>> that triggering it on inotify events is liable to cause performance
>> issues and possibly lose changes
> 
> Actually triggering doesn't happen on each and every inotify event.
> lsyncd has an option to define a time interval within which all inotify
> events are accumulated and only then rsync is launched. It could be 5-10
> seconds or more. Which is quasi real time sync. Do you  still hold that
> it will not work with BTRFS send/receive (i.e. keeping previous snapshot
> around and creating a new one)?
Okay, I actually didn't know that.  Depending on how lsyncd invokes 
rsync though (does it call out rsync with the exact paths or just on the 
whole directory?), it may still be less efficient to use BTRFS send/receive.
> 
>>   (contrary to popular belief, snapshot
>> creation is neither atomic nor free).  It also means that if you want to
>> match rsync performance in terms of network usage, you're going to have
>> to keep the previous snapshot around so you can do an incremental send
>> (which is also less efficient than rsync's file comparison, unless rsync
>> is checksumming files).
> 
> Indeed? From what I've read so far I got an impression that rsync is
> slower... but I might be wrong... Is this by design so, or can BTRFS
> beat rsync in future (even without checksumming)?
It really depends.  BTRFS send/receive transfers _everything_, period. 
Any xattrs, any ACL's, any other metadata, everything.  Rsync can 
optionally not transfer some of that data (and by default doesn't), so 
if you don't need all of that (and most people don't need xattrs or 
ACL's transferred), rsync is usually going to be faster.  When you 
actually are transferring everything, send/receive is probably faster, 
and it's definitely faster than rsync with checksumming.

There's one other issue at hand though that I had forgot to mention. 
The current implementation of send/receive doesn't properly validate 
sources for reflinks, which means it's possible to create an information 
leak with a carefully crafted send stream and some pretty minimal 
knowledge of the destination filesystem.  Whether or not this matters is 
of course specific to your use case.
> 
>>
>> Because of this, it would be pretty complicated right now to get lsyncd
>> reliable integration.
>>
>>> Otherwise I can sync using btrfs send/receive from within cron every
>>> 10-15 minutes, but it seems less elegant.When it comes to stuff like this, it's usually best to go for the
>> simplest solution that meets your requirements.  Unless you need
>> real-time synchronization, inotify is overkill,
> 
> I actually got inotify-based lsyncd working and I like it... however
> real-time syncing is not a must, and several years everything worked
> well with a simple rsync within a cron every 15 minutes. Could you
> please elaborate on the disadvantages of lsyncd, so maybe I should
> switch back? For example, in which of two cases the life of the hard
> drive is negatively impacted? On one side the data doesn't change too
> often, so 98% of rsync's from cron are wasted, on the other triggering a
> rsync on inotify might be too intensive task for a hard drive? What do
> you think? What other considerations could be?
The biggest one is largely irrelevant if lsyncd batches transfers, and 
arises from the possibility of events firing faster than you can handle 
them (which runs the risk of events getting lost, and in turn things 
getting out of sync).  The other big one (for me at least) is 
determinism.  With a cron job, you know exactly when things will get 
copied, and in turn exactly when the system will potentially be under 
increased load (which makes it a lot easier to quickly explain to users 
why whatever they were doing unexpectedly took longer than normal).
> 
> 
>>   and unless you need to
>> copy reflinks (you probably don't, as almost nothing uses them yet, and
>> absolutely nothing I know of depends on them) send/receive is overkill.
> 
> I saw in a post that rsync would create a separate copy of a cloned file
> (consuming double space and maybe traffic?)
That's correct, but you technically need to have that extra space in 
most cases anyway, since you can't assume nothing will write to that 
file and double the space usage.
> 
>> As a pretty simple example, we've got a couple of systems that have
>> near-line active backups set up.  The data is stored on BTRFS, but we
>> just use a handful of parallel rsync invocations every 15 minutes to
>> keep the backup system in sync (because of what we do, we can afford to
>> lose 15 minutes of data).  It's not 'elegant', but it's immediately
>> obvious to any seasoned sysadmin what it's doing, and it gets the job
>> done easily syncing the data in question in at most a few minutes.  Back
>> when I switched to using BTRFS, I considered using send/receive, but
>> even using incremental send/receive still performed worse than rsync.
>>>
>>> 4. In a case when compression is used - what quota is based on - (a)
>>> amount of GBs the data actually consumes on the hard drive while in
>>> compressed state or (b) amount of GBs the data naturally is in
>>> uncompressed form. I need to set quotas as in (b). Is it possible? If
>>> not - should I file a feature request?
>> I can't directly answer this as I don't know myself (I don't use
>> quotas), but have two comments I would suggest you consider:
>>
>> 1. qgroups (the BTRFS quota implementation) cause scaling and
>> performance issues.  Unless you absolutely need quotas (unless you're a
>> hosting company, or are dealing with users who don't listen and don't
>> pay attention to disk usage, you usually do not need quotas), you're
>> almost certainly better off disabling them for now, especially for a
>> production system.
> 
> Ok. I'll use more standard approaches. Which of following commands will
> work with BTRFS:
> 
> https://debian-handbook.info/browse/stable/sect.quotas.html
None, qgroups are the only option right now with BTRFS, and it's pretty 
likely to stay that way since the internals of the filesystem don't fit 
well within the semantics of the regular VFS quota API.  However, 
provided you're not using huge numbers of reflinks and subvolumes, you 
should be fine using qgroups.

However, it's important to know that if your users have shell access, 
they can bypass qgroups.  Normal users can create subvolumes, and new 
subvolumes aren't added to an existing qgroup by default (and unless I'm 
mistaken, aren't constrained by the qgroup set on the parent subvolume), 
so simple shell access is enough to bypass quotas.
> 
>>
>> 2. Compression and quotas cause issues regardless of how they interact.
>> In case (a), the user has no way of knowing if a given file will fit
>> under their quota until they try to create it.  In case (b), actual disk
>> usage (as reported by du) will not match up with what the quota says the
>> user is using, which makes it harder for them to figure out what to
>> delete to free up space.  It's debatable which is a less objectionable
>> situation for users, though most people I know tend to think in a way
>> that the issue with (a) doesn't matter, but the issue with (b) does.
> 
> I think both (a) and (b) should be possible and it should be up to
> sysadmin to choose what he prefers. The concerns of the (b) scenario
> probably could be dealt with some sort of --real-size to the du command,
> while by default it could have behavior (which might be emphasized with
> --compressed-size).
Reporting anything but the compressed size by default in du would mean 
it doesn't behave as existing software expect it to.  It's supposed to 
report actual disk usage (in contrast to the sum of file sizes), which 
means for example that a 1G sparse file with only 64k of data is 
supposed to be reported as being 64k by du.
> 
> Two more question came to my mind: as I've mentioned above - I have two
> boxes one syncs to another. No RAID involved. I want to scrub (or scan -
> don't know yet, what is the difference...) the whole filesystem once in
> a month to look for bitrot. Questions:
> 
> 1. is it a stable setup for production? Let's say I'll sync with rsync -
> either in cron or in lsyncd?
Reasonably, though depending on how much data and other environmental 
constraints, you may want to scrub a bit more frequently.
> 2. should any data corruption be discovered - is there any way to heal
> it using the copy from the other box over SSH?
Provided you know which file is affected, yes, you can fix it by just 
copying the file back from the other system.

