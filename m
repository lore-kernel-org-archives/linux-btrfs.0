Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:48486 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753718AbdJaRpi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:45:38 -0400
Received: by mail-io0-f176.google.com with SMTP id j17so549889iod.5
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 10:45:37 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
References: <1509467017.1662.37.camel@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
Date: Tue, 31 Oct 2017 13:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <1509467017.1662.37.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 12:23, ST wrote:
> Hello,
> 
> I've recently learned about btrfs and consider to utilize for my needs.
> I have several questions in this regard:
> 
> I manage a dedicated server remotely and have some sort of script that
> installs an OS from several images. There I can define partitions and
> their FSs.
> 
> 1. By default the script provides a small separate partition for /boot
> with ext3. Does it have any advantages or can I simply have /boot
> within / all on btrfs? (Note: the OS is Debian9)
It depends on the boot loader.  I think Debian 9's version of GRUB has 
no issue with BTRFS, but see the response below to your question on 
subvolumes for the one caveat.
> 
> 2. as for the / I get ca. following written to /etc/fstab:
> UUID=blah_blah /dev/sda3 / btrfs ...
> So top-level volume is populated after initial installation with the
> main filesystem dir-structure (/bin /usr /home, etc..). As per btrfs
> wiki I would like top-level volume to have only subvolumes (at least,
> the one mounted as /) and snapshots. I can make a snapshot of the
> top-level volume with / structure, but how can get rid of all the
> directories within top-lvl volume and keep only the subvolume
> containing / (and later snapshots), unmount it and then mount the
> snapshot that I took? rm -rf / - is not a good idea...
There are three approaches to doing this, from a live environment, from 
single user mode running with init=/bin/bash, or from systemd emergency 
mode.  Doing it from a live environment is much safer overall, even if 
it does take a bit longer.  I'm listing the last two methods here only 
for completeness, and I very much suggest that you use the first (do it 
from a live environment).

Regardless of which method you use, if you don't have a separate boot 
partition, you will have to create a symlink called /boot outside the 
subvolume, pointing at the boot directory inside the subvolume, or 
change the boot loader to look at the new location for /boot.

 From a live environment, it's pretty simple overall, though it's much 
easier if your live environment matches your distribution:
1. Create the snapshot of the root, naming it what you want the 
subvolume to be called (I usually just call it root, SUSE and Ubuntu 
call it @, others may have different conventions).
2. Delete everything except the snapshot you just created.  The safest 
way to do this is to explicitly list each individual top-level directory 
to delete.
3. Use `btrfs subvolume list` to figure out the subvolume ID for the 
subvolume you just created, and then set that as the default subvolume 
with `btrfs subvolume set-default /path SUBVOLID`.  Once you do this, 
you will need to specify subvolid=5 in the mount options to get the real 
top-level subvolume.
4. Reboot.

For single user mode (check further down for what to do with systemd, 
also note that this may brick your system if you get it wrong):
1. When booting up the system, stop the bootloader and add 
'init=/bin/bash' to the kernel command line before booting.
2. When you get a shell prompt, create the snapshot, just like above.
3. Run the following:
'cd /path ; mkdir old_root ; pivot_root . old_root ; chroot . /bin/bash'
3. You're now running inside the new subvolume, and the old root 
filesystem is mounted at /old_root.  From here, just follow steps 2 to 4 
from the live environment method.

For doing it from emergency mode, things are a bit more complicated:
1. Create the snapshot of the root, just like above.
2. Make sure the only services running are udev and systemd-journald.
3. Run `systemctl switch-root` with the path to the subvolume you just 
created.
4. You're now running inside the new root, systemd _may_ try to go all 
the way to a full boot now.
5. Mount the root filesystem somewhere, and follow steps 2 through 4 of 
the live environment method.
> 
> 3. in my current ext4-based setup I have two servers while one syncs
> files of certain dir to the other using lsyncd (which launches rsync on
> inotify events). As far as I have understood it is more efficient to use
> btrfs send/receive (over ssh) than rsync (over ssh) to sync two boxes.
> Do you think it would be possible to make lsyncd to use btrfs for
> syncing instead of rsync? I.e. can btrfs work with inotify events? Did
> somebody try it already?
BTRFS send/receive needs a read-only snapshot to send from.  This means 
that triggering it on inotify events is liable to cause performance 
issues and possibly lose changes (contrary to popular belief, snapshot 
creation is neither atomic nor free).  It also means that if you want to 
match rsync performance in terms of network usage, you're going to have 
to keep the previous snapshot around so you can do an incremental send 
(which is also less efficient than rsync's file comparison, unless rsync 
is checksumming files).

Because of this, it would be pretty complicated right now to get lsyncd 
reliable integration.

> Otherwise I can sync using btrfs send/receive from within cron every
> 10-15 minutes, but it seems less elegant.When it comes to stuff like this, it's usually best to go for the 
simplest solution that meets your requirements.  Unless you need 
real-time synchronization, inotify is overkill, and unless you need to 
copy reflinks (you probably don't, as almost nothing uses them yet, and 
absolutely nothing I know of depends on them) send/receive is overkill.

As a pretty simple example, we've got a couple of systems that have 
near-line active backups set up.  The data is stored on BTRFS, but we 
just use a handful of parallel rsync invocations every 15 minutes to 
keep the backup system in sync (because of what we do, we can afford to 
lose 15 minutes of data).  It's not 'elegant', but it's immediately 
obvious to any seasoned sysadmin what it's doing, and it gets the job 
done easily syncing the data in question in at most a few minutes.  Back 
when I switched to using BTRFS, I considered using send/receive, but 
even using incremental send/receive still performed worse than rsync.
> 
> 4. In a case when compression is used - what quota is based on - (a)
> amount of GBs the data actually consumes on the hard drive while in
> compressed state or (b) amount of GBs the data naturally is in
> uncompressed form. I need to set quotas as in (b). Is it possible? If
> not - should I file a feature request?
I can't directly answer this as I don't know myself (I don't use 
quotas), but have two comments I would suggest you consider:

1. qgroups (the BTRFS quota implementation) cause scaling and 
performance issues.  Unless you absolutely need quotas (unless you're a 
hosting company, or are dealing with users who don't listen and don't 
pay attention to disk usage, you usually do not need quotas), you're 
almost certainly better off disabling them for now, especially for a 
production system.

2. Compression and quotas cause issues regardless of how they interact. 
In case (a), the user has no way of knowing if a given file will fit 
under their quota until they try to create it.  In case (b), actual disk 
usage (as reported by du) will not match up with what the quota says the 
user is using, which makes it harder for them to figure out what to 
delete to free up space.  It's debatable which is a less objectionable 
situation for users, though most people I know tend to think in a way 
that the issue with (a) doesn't matter, but the issue with (b) does.
