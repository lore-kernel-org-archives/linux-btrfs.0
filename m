Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:47036 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdKFNvQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 08:51:16 -0500
Received: by mail-io0-f181.google.com with SMTP id 101so15728434ioj.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 05:51:16 -0800 (PST)
Subject: Re: updatedb does not index /home when /home is Btrfs
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
 <20171104044916.4mpgaails24rqddz@angband.pl>
 <65c3c537-1e30-87ae-140a-b59bdd79a4dc@gmail.com>
 <20171104070550.lr5osyfz74axw5nl@angband.pl>
 <32e2df81-51c0-396b-57af-132907918935@gmail.com>
 <CAJCQCtTXR9vBhUPxzkz2RWsD3=WWzNA20w3vCdjzrrHA8eiF-g@mail.gmail.com>
 <b5e7e64a-741c-baee-bc4d-cd51ca9b3a38@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <78727726-c7fc-c645-d805-ef746a81b715@gmail.com>
Date: Mon, 6 Nov 2017 08:51:11 -0500
MIME-Version: 1.0
In-Reply-To: <b5e7e64a-741c-baee-bc4d-cd51ca9b3a38@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-05 03:01, Andrei Borzenkov wrote:
> 04.11.2017 21:55, Chris Murphy пишет:
>> On Sat, Nov 4, 2017 at 12:27 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>> 04.11.2017 10:05, Adam Borowski пишет:
>>>> On Sat, Nov 04, 2017 at 09:26:36AM +0300, Andrei Borzenkov wrote:
>>>>> 04.11.2017 07:49, Adam Borowski пишет:
>>>>>> On Fri, Nov 03, 2017 at 06:15:53PM -0600, Chris Murphy wrote:
>>>>>>> Ancient bug, still seems to be a bug.
>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=906591
>>>>>>>
>>>>>>> The issue is that updatedb by default will not index bind mounts, but
>>>>>>> by default on Fedora and probably other distros, put /home on a
>>>>>>> subvolume and then mount that subvolume which is in effect a bind
>>>>>>> mount.
>>>>>>>
>>>>>>> There's a lot of early discussion in 2013 about it, but then it's
>>>>>>> dropped off the radar as nobody has any ideas how to fix this in
>>>>>>> mlocate.
>>>>>>
>>>>>> I don't see how this would be a bug in btrfs.  The same happens if you
>>>>>> bind-mount /home (or individual homes), which is a valid and non-rare setup.
>>>>>
>>>>> It is the problem *on* btrfs because - as opposed to normal bind mount -
>>>>> those mount points do *not* refer to the same content.
>>>>
>>>> Neither do they refer to in a "normal" bind mount.
>>>>
>>>>> As was commented in mentioned bug report:
>>>>>
>>>>> mount -o subvol=root /dev/sdb1 /root
>>>>> mount -o subvol=foo /dev/sdb1 /root/foo
>>>>> mount -o subvol bar /dev/sdb1 /bar/bar
>>>>>
>>>>> Both /root/foo and /root/bar, will be skipped even though they are not
>>>>> accessible via any other path (on mounted filesystem)
>>>>
>>>> losetup -D
>>>> truncate -s 4G junk
>>>> losetup -f junk
>>>> mkfs.ext4 /dev/loop0
>>>> mkdir -p foo bar
>>>> mount /dev/loop0 foo
>>>> mkdir foo/bar
>>>> touch foo/fileA foo/bar/fileB
>>>> mount --bind foo/bar bar
>>>> umount foo
>>>>
>>>
>>> Indeed. I can build the same configuration on non-btrfs and updatedb
>>> would skip non-overlapping mounts just as it would on btrfs. It is just
>>> that it is rather more involved on other filesystems (and as you
>>> mentioned this requires top-level to be mounted at some point), while on
>>> btrfs it is much easier to get (and is default on number of distributions).
>>>
>>> So yes, it really appears that updatedb check for duplicated mounts is
>>> wrong in general and needs rethinking.
>>
>> Yes, even if it's not a Btrfs bug, I think it's useful to get a
>> different set of eyes on this than just the mlocate folks. Maybe it
>> should get posted to fs-devel?
>>
> 
> Looking at mlocate history, initial bind detection was extremely
> simplistic but actually correct, and would still work even with btrfs -
> just look in /etc/mtab for mount with "bind" option where what != where.
> This covers any sort of bind mount.
> 
> Later /etc/mtab disappeared and code was rewritten to use mountinfo.
> Intentionally or not, this rewrite only works for bind mounts inside the
> same filesystem subtree. I.e. it also won't catch cross filesystem bind
> mounts. Failure on btrfs is side effect of this assumption.
This brings to mind another 'feature' of BTRFS that I came across 
recently, namely that subvolumes that aren't explicitly mounted still 
show up as mount points according to how most CLI tools differentiate 
what's a mount point.

In particular, the st_dev field in stat() results for the subvolume 
differs from the containing directory, and the f_fsid field in statvfs() 
results for the subvolume differs from the containing directory (a side 
effect of the differing st_dev field, which is part of what's used to 
calculate f_fsid on Linux), which means the only way to know if 
something actually is a mount point is to make this check, and then 
verify it in /proc/mounts or /proc/self/mountinfo.

That particular 'feature' means that GNU find, xargs, and du will never 
cross subvolume boundaries if you tell them to stay on one filesystem, 
and some other tools may misidentify where things are mounted.
> 
> So it actually can be considered regression in mlocate code.
> 
> I suppose first mlocate folks need to get clear answer what they want to
> test here, then it makes sense to discuss how to do it.
Agreed.
