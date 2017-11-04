Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:44021 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdKDS1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 14:27:04 -0400
Received: by mail-lf0-f43.google.com with SMTP id a16so6479265lfk.0
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Nov 2017 11:27:03 -0700 (PDT)
Subject: Re: updatedb does not index /home when /home is Btrfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
 <20171104044916.4mpgaails24rqddz@angband.pl>
 <65c3c537-1e30-87ae-140a-b59bdd79a4dc@gmail.com>
 <20171104070550.lr5osyfz74axw5nl@angband.pl>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <32e2df81-51c0-396b-57af-132907918935@gmail.com>
Date: Sat, 4 Nov 2017 21:27:00 +0300
MIME-Version: 1.0
In-Reply-To: <20171104070550.lr5osyfz74axw5nl@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

04.11.2017 10:05, Adam Borowski пишет:
> On Sat, Nov 04, 2017 at 09:26:36AM +0300, Andrei Borzenkov wrote:
>> 04.11.2017 07:49, Adam Borowski пишет:
>>> On Fri, Nov 03, 2017 at 06:15:53PM -0600, Chris Murphy wrote:
>>>> Ancient bug, still seems to be a bug.
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=906591
>>>>
>>>> The issue is that updatedb by default will not index bind mounts, but
>>>> by default on Fedora and probably other distros, put /home on a
>>>> subvolume and then mount that subvolume which is in effect a bind
>>>> mount.
>>>>
>>>> There's a lot of early discussion in 2013 about it, but then it's
>>>> dropped off the radar as nobody has any ideas how to fix this in
>>>> mlocate.
>>>
>>> I don't see how this would be a bug in btrfs.  The same happens if you
>>> bind-mount /home (or individual homes), which is a valid and non-rare setup.
>>
>> It is the problem *on* btrfs because - as opposed to normal bind mount -
>> those mount points do *not* refer to the same content.
> 
> Neither do they refer to in a "normal" bind mount.
> 
>> As was commented in mentioned bug report:
>>
>> mount -o subvol=root /dev/sdb1 /root
>> mount -o subvol=foo /dev/sdb1 /root/foo
>> mount -o subvol bar /dev/sdb1 /bar/bar
>>
>> Both /root/foo and /root/bar, will be skipped even though they are not
>> accessible via any other path (on mounted filesystem)
> 
> losetup -D
> truncate -s 4G junk
> losetup -f junk
> mkfs.ext4 /dev/loop0
> mkdir -p foo bar
> mount /dev/loop0 foo
> mkdir foo/bar
> touch foo/fileA foo/bar/fileB
> mount --bind foo/bar bar
> umount foo
> 

Indeed. I can build the same configuration on non-btrfs and updatedb
would skip non-overlapping mounts just as it would on btrfs. It is just
that it is rather more involved on other filesystems (and as you
mentioned this requires top-level to be mounted at some point), while on
btrfs it is much easier to get (and is default on number of distributions).

So yes, it really appears that updatedb check for duplicated mounts is
wrong in general and needs rethinking.
