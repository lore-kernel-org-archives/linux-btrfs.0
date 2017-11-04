Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:50709 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdKDG0l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 02:26:41 -0400
Received: by mail-lf0-f43.google.com with SMTP id a132so5344055lfa.7
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Nov 2017 23:26:41 -0700 (PDT)
Subject: Re: updatedb does not index /home when /home is Btrfs
To: Adam Borowski <kilobyte@angband.pl>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
 <20171104044916.4mpgaails24rqddz@angband.pl>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <65c3c537-1e30-87ae-140a-b59bdd79a4dc@gmail.com>
Date: Sat, 4 Nov 2017 09:26:36 +0300
MIME-Version: 1.0
In-Reply-To: <20171104044916.4mpgaails24rqddz@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

04.11.2017 07:49, Adam Borowski пишет:
> On Fri, Nov 03, 2017 at 06:15:53PM -0600, Chris Murphy wrote:
>> Ancient bug, still seems to be a bug.
>> https://bugzilla.redhat.com/show_bug.cgi?id=906591
>>
>> The issue is that updatedb by default will not index bind mounts, but
>> by default on Fedora and probably other distros, put /home on a
>> subvolume and then mount that subvolume which is in effect a bind
>> mount.
>>
>> There's a lot of early discussion in 2013 about it, but then it's
>> dropped off the radar as nobody has any ideas how to fix this in
>> mlocate.
> 
> I don't see how this would be a bug in btrfs.  The same happens if you
> bind-mount /home (or individual homes), which is a valid and non-rare setup.
> 

It is the problem *on* btrfs because - as opposed to normal bind mount -
those mount points do *not* refer to the same content. As was commented
in mentioned bug report:

mount -o subvol=root /dev/sdb1 /root
mount -o subvol=foo /dev/sdb1 /root/foo
mount -o subvol bar /dev/sdb1 /bar/bar

Both /root/foo and /root/bar, will be skipped even though they are not
accessible via any other path (on mounted filesystem)


191 25 0:54 /root /home/bor/tmp/root rw,relatime shared:131 - btrfs
/dev/loop0 rw,space_cache,subvolid=258,subvol=/root
285 191 0:54 /foo /home/bor/tmp/root/foo rw,relatime shared:239 - btrfs
/dev/loop0 rw,space_cache,subvolid=256,subvol=/foo
325 191 0:54 /bar /home/bor/tmp/root/bar rw,relatime shared:279 - btrfs
/dev/loop0 rw,space_cache,subvolid=257,subvol=/bar

bor@bor-Latitude-E5450:~/tmp$ sudo updatedb --debug-pruning -l 0 -o
../db -U root
...
Matching bind_mount_paths:
 => adding `/home/bor/tmp/root/foo'
 => adding `/home/bor/tmp/root/bar'
...done


It is a problem *of* btrfs because it does not offer any easy way to
distinguish between subvolume mount and bind mount. If you are aware of
one, please comment on mentioned bug report.

And note that updatedb can be run as non-root as well, so it probably
cannot use btrfs specific ioctls to extract information.
