Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36616 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbcGFSNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 14:13:18 -0400
Received: by mail-oi0-f43.google.com with SMTP id f189so281968868oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 11:12:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3a554136-ba08-0b9d-7ef7-7a9d6c42f217@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com> <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com> <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com> <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
 <04874cd6-b043-2743-8e6e-f0ebd61400ed@gmail.com> <CAJCQCtTAMHYBQ+PCrrsMcRW_yhyp8dqmOrLsujEHxy+jq1rOrw@mail.gmail.com>
 <3a554136-ba08-0b9d-7ef7-7a9d6c42f217@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 12:12:54 -0600
Message-ID: <CAJCQCtSuVzykDn+Xk31dSjdgRVOhGxy77dAwuo2aTeAB7XY8hw@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 11:50 AM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:
> sudo mount -o ro /dev/sdc /shares
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
>
>
> sudo mount -o ro,recovery /dev/sdc /shares
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.


[ 275.688919] BTRFS error (device sda): parent transid verify failed
on 7008533413888 wanted 70175 found 70132

Looks like the generation is too far back for backup roots.

Just for grins, now that all drives are present, what do you get for

# btrfs rescue super-recover -v /dev/sda

Next I suggest btrfs-image -c9 -t4 and optionally -s to sanitize file
names. And also btrfs-debug-tree (this time no -d) redirected to a
file. These two files can be big, about the size of the used amount of
metadata chunks. These go in the cloud at some point, reference them
in a bugzilla.kernel.org bug report by URL. Expect it to be months
before a dev looks at it.

So now what you want to try to do is use restore.
https://btrfs.wiki.kernel.org/index.php/Restore

You can use the information from btrfs-find-root to give restore a -t
value to try. For example:

>Found tree root at 6062830010368 gen 70182 level 1
>Well block 6062434418688(gen: 70181 level: 1) seems good, but
>generation/level doesn't match, want gen: 70182 level: 1
>Well block 6062497202176(gen: 69186 level: 0) seems good, but
>generation/level doesn't match, want gen: 70182 level: 1
>Well block 6062470332416(gen: 69186 level: 0) seems good, but
>generation/level doesn't match, want gen: 70182 level: 1


btrfs restore -t 6062830010368 -v -i /dev/sda <pathtowhereyouwantdatatogo>

If that fails totally you can try the next bytenr, for the -t value,
6062434418688. And then the next. Each value down is going backward in
time, so it implies some data loss.

This is not the end. It's just that it's the safest since no changes
to the fs have happened. If you set up some kind of overlay you can be
more aggressive like going right for btrfs check --repair and seeing
if it can fix things, but without the overlay it's possible to totally
break the fs such that even restore won't work.

Once you pretty much have everything important off the volume, you can
get more aggressive with trying to fix it. OR just blow it away and
start over. But I think it's valid to gather as much information about
the file system and try to fix it because the autopsy is the main way
to make Btrfs better.



-- 
Chris Murphy
