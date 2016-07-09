Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34013 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbcGISdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jul 2016 14:33:40 -0400
Received: by mail-oi0-f53.google.com with SMTP id s66so99895240oif.1
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jul 2016 11:33:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0b23ddfd-c1df-4837-ef13-7df027c88508@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com> <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com> <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com> <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
 <04874cd6-b043-2743-8e6e-f0ebd61400ed@gmail.com> <CAJCQCtTAMHYBQ+PCrrsMcRW_yhyp8dqmOrLsujEHxy+jq1rOrw@mail.gmail.com>
 <3a554136-ba08-0b9d-7ef7-7a9d6c42f217@gmail.com> <CAJCQCtSuVzykDn+Xk31dSjdgRVOhGxy77dAwuo2aTeAB7XY8hw@mail.gmail.com>
 <0b23ddfd-c1df-4837-ef13-7df027c88508@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 9 Jul 2016 12:33:39 -0600
Message-ID: <CAJCQCtSA9TXO5dEZ-77hoFnc3VAa+81KRoEx9CoJhfStvW3O0A@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 9, 2016 at 11:30 AM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:
>  sudo btrfs rescue super-recover -v /dev/sda
> All Devices:
>         Device: id = 1, name = /dev/sdc
>         Device: id = 2, name = /dev/sdb
>         Device: id = 3, name = /dev/sda
>
> Before Recovering:
>         [All good supers]:
>                 device name = /dev/sdc
>                 superblock bytenr = 65536
>
>                 device name = /dev/sdc
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sdc
>                 superblock bytenr = 274877906944
>
>                 device name = /dev/sdb
>                 superblock bytenr = 65536
>
>                 device name = /dev/sdb
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sdb
>                 superblock bytenr = 274877906944
>
>                 device name = /dev/sda
>                 superblock bytenr = 65536
>
>                 device name = /dev/sda
>                 superblock bytenr = 67108864
>
>                 device name = /dev/sda
>                 superblock bytenr = 274877906944
>
>         [All bad supers]:
>
> All supers are valid, no need to recover
>
>
> I hope, a made it right:
>
>
> sudo btrfs-image -c9 -t4 /dev/sda /mnt/btrfs-image
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> checksum verify failed on 7008807157760 found F192848C wanted 1571393A
> checksum verify failed on 7008807157760 found F192848C wanted 1571393A
> bytenr mismatch, want=7008807157760, have=65536
> parent transid verify failed on 7009074167808 wanted 70175 found 70133
> parent transid verify failed on 7009074167808 wanted 70175 found 70133
> checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
> checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
> bytenr mismatch, want=7009074167808, have=65536
> Error going to next leaf -5
> create failed (Success)

I've always found that to be a confusing message at the end. If you've
got something in the realm of the total used amount of metadata block
groups (what you'd see with 'fi df' or 'fi usage' then it's  probably
OK.

>
>
> sudo btrfs-debug-tree /dev/sda > /mnt/btrfs-debug-tree 2>
> /mnt/btrfs-debug-tree-err
>
> btrfs-debug-tree file have 10MB
> btrfs-debug-tree-err
> http://sebsauvage.net/paste/?12cf2fb771b93bdd#Ajv5gPoxDKjaWExcJnMZLVhcU5wVw77abeZ4tIGTazU=

Huh so not very useful compared to with -d, it must be tripping up on
something. I guess you could try btrfs-progs 4.6.1 and see if you get
any different results, at the least, btrfs-debug-tree shouldn't crash.

>> I used btrfs restore and everything except the newest files was restored.
> I can get those files again from the internet, so now it is save to do
> changes to filesystem and try to repair it.
> In the end, I will create new fs, but I can try to repair it and
> hopefully gather some helpful information.
>
> Thank you for help...

So now it's an open question what to try and in what order, and I'm
afraid I'm only making estimated guesses. Ideally you'd set up some
kind of overlay so that you can try different sequences in a way
that's non-destructive to the original, but just make sure whatever
overlay method you use obscures the original file system from the
kernel or you run into the problem of having the same volume UUID
exposed more than once, which presently can corrupt both copies.

I would try them in the following order where you try to mount after
each and only try the next one if mount fails.

btrfs check --repair
btrfs check -r <tree root bytenr> --repair

Use the tree root bytenr you used for mostly successful recovery for
'btrfs restore -t' but if that doesn't work then I'd try all the tree
roots that btrfs-find-root reports.

btrfs check --repair --init-csum-tree
btrfs check --repair --init-extent-tree

Those aren't really related to your problem at all, it's just
spaghetti at a wall. Likewise the following two:

btrfs restore chunk-recover
btrfs restore zero-log

In particular there's nothing about your situation that suggests zero
log ought to fix anything. But stranger things have happened.


-- 
Chris Murphy
