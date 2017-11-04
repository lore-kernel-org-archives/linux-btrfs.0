Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:48767 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750959AbdKDTho (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 15:37:44 -0400
Received: by mail-oi0-f54.google.com with SMTP id m198so4448266oig.5
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Nov 2017 12:37:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTXR9vBhUPxzkz2RWsD3=WWzNA20w3vCdjzrrHA8eiF-g@mail.gmail.com>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
 <20171104044916.4mpgaails24rqddz@angband.pl> <65c3c537-1e30-87ae-140a-b59bdd79a4dc@gmail.com>
 <20171104070550.lr5osyfz74axw5nl@angband.pl> <32e2df81-51c0-396b-57af-132907918935@gmail.com>
 <CAJCQCtTXR9vBhUPxzkz2RWsD3=WWzNA20w3vCdjzrrHA8eiF-g@mail.gmail.com>
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Sat, 4 Nov 2017 15:37:43 -0400
Message-ID: <CAD=QJKgdiG7o8fayb=AXseUF6KDWsqk51Caua0nMiprvveG9yg@mail.gmail.com>
Subject: Re: updatedb does not index /home when /home is Btrfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 November 2017 at 14:55, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Nov 4, 2017 at 12:27 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>> 04.11.2017 10:05, Adam Borowski пишет:
>>> On Sat, Nov 04, 2017 at 09:26:36AM +0300, Andrei Borzenkov wrote:
>>>> 04.11.2017 07:49, Adam Borowski пишет:
>>>>> On Fri, Nov 03, 2017 at 06:15:53PM -0600, Chris Murphy wrote:
>>>>>> Ancient bug, still seems to be a bug.
>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=906591
>>>>>>
>>>>>> The issue is that updatedb by default will not index bind mounts, but
>>>>>> by default on Fedora and probably other distros, put /home on a
>>>>>> subvolume and then mount that subvolume which is in effect a bind
>>>>>> mount.
>>>>>>
>>>>>> There's a lot of early discussion in 2013 about it, but then it's
>>>>>> dropped off the radar as nobody has any ideas how to fix this in
>>>>>> mlocate.
>>>>>
>>>>> I don't see how this would be a bug in btrfs.  The same happens if you
>>>>> bind-mount /home (or individual homes), which is a valid and non-rare setup.
>>>>
>>>> It is the problem *on* btrfs because - as opposed to normal bind mount -
>>>> those mount points do *not* refer to the same content.
>>>
>>> Neither do they refer to in a "normal" bind mount.
>>>
>>>> As was commented in mentioned bug report:
>>>>
>>>> mount -o subvol=root /dev/sdb1 /root
>>>> mount -o subvol=foo /dev/sdb1 /root/foo
>>>> mount -o subvol bar /dev/sdb1 /bar/bar
>>>>
>>>> Both /root/foo and /root/bar, will be skipped even though they are not
>>>> accessible via any other path (on mounted filesystem)
>>>
>>> losetup -D
>>> truncate -s 4G junk
>>> losetup -f junk
>>> mkfs.ext4 /dev/loop0
>>> mkdir -p foo bar
>>> mount /dev/loop0 foo
>>> mkdir foo/bar
>>> touch foo/fileA foo/bar/fileB
>>> mount --bind foo/bar bar
>>> umount foo
>>>
>>
>> Indeed. I can build the same configuration on non-btrfs and updatedb
>> would skip non-overlapping mounts just as it would on btrfs. It is just
>> that it is rather more involved on other filesystems (and as you
>> mentioned this requires top-level to be mounted at some point), while on
>> btrfs it is much easier to get (and is default on number of distributions).
>>
>> So yes, it really appears that updatedb check for duplicated mounts is
>> wrong in general and needs rethinking.
>
> Yes, even if it's not a Btrfs bug, I think it's useful to get a
> different set of eyes on this than just the mlocate folks. Maybe it
> should get posted to fs-devel?

How is this not a configuration issue?  For btrfs users why not just
recommend PRUNE_BIND_MOUNTS="no" and a particular set of PRUNEPATHS?

I have each top-level subvolume (id=5 or subvol=/) mounted at
/btrfs-admin/$LABEL, where /btrfs-admin is root:sudo 750, and this is
what I use in /etc/updatedb.conf:

PRUNE_BIND_MOUNTS="no"
PRUNENAMES=".git .bzr .hg .svn"
PRUNEPATHS="/tmp /var/spool /media /btrfs-admin /var/cache /var/lib/lxc"
PRUNEFS="NFS nfs nfs4 rpc_pipefs afs binfmt_misc proc smbfs autofs
iso9660 ncpfs coda devpts ftpfs devfs mfs shfs sysfs cifs lustre tmpfs
usbfs udf fuse.glusterfs fuse.sshfs curlftpfs"

With the exception of LXC rootfss I have a flat subvolume structure
under each subvol=/.  These subvolumes are mounted at specific
mountpoints using fstab.  Given that updatedb and locate work
flawlessly, and that I've only had two issues (freespacecache) while
using LTS kernels, I'm inclined to conclude that this is the least
disruptive configuration.  If I used snapper I'd add it to PRUNEPATHS
and rely on its facilities to find files that had been deleted,
because I don't want to see n-duplicates-for-file when I use locate.
A user who wanted to see those duplicates could remove the path from
PRUNEPATHS.

Sincerely,
Nicholas
