Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:52852 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaKCC4K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Nov 2014 21:56:10 -0500
Received: by mail-vc0-f170.google.com with SMTP id la4so4427035vcb.15
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Nov 2014 18:56:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5455B7E7.3020404@pobox.com>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
 <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com>
 <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
 <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com> <5455B7E7.3020404@pobox.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Mon, 3 Nov 2014 03:55:48 +0100
Message-ID: <CAGwxe4i1=S-qgp91YjqH11juaGx6h0FyM7rDAWhFix+beCRgPw@mail.gmail.com>
Subject: Re: filesystem corruption
To: Robert White <rwhite@pobox.com>
Cc: Rich Freeman <r-btrfs@thefreemanclan.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your reply.

I'll answer in-line.


2014-11-02 5:49 GMT+01:00 Robert White <rwhite@pobox.com>:
> On 10/31/2014 10:34 AM, Tobias Holst wrote:
>>
>> I am now using another system with kernel 3.17.2 and btrfs-tools 3.17
>> and inserted one of the two HDDs of my btrfs-RAID1 to it. I can't add
>> the second one as there are only two slots in that server.
>>
>> This is what I got:
>>
>>   tobby@ubuntu: sudo btrfs check /dev/sdb1
>> warning, device 2 is missing
>> warning devid 2 not found already
>> root item for root 1746, current bytenr 80450240512, current gen
>> 163697, current level 2, new bytenr 40074067968, new gen 163707, new
>> level 2
>> Found 1 roots with an outdated root item.
>> Please run a filesystem check with the option --repair to fix them.
>>
>>   tobby@ubuntu: sudo btrfs check --repair /dev/sdb1
>> enabling repair mode
>> warning, device 2 is missing
>> warning devid 2 not found already
>> Unable to find block group for 0
>> extent-tree.c:289: find_search_start: Assertion `1` failed.
>
>
> The read-only snapshots taken under 3.17.1 are your core problem.

OK

>
> Now btrfsck is refusing to operate on the degraded RAID because degraded
> RAID is degraded so it's read-only. (this is an educated guess). Since
> btrfsck is _not_ a mount type of operation its got no "degraded mode" that
> would let you deal with half a RAID as far as I know.

OK, good to know.

>
> In your case...
>
> It is _known_ that you need to be _not_ running 3.17.0 or 3.17.1 if you are
> going to make read-only snapshots safely.
> It is _known_ that you need to be running 3.17.2 to get a number of fixes
> that impact your circumstance.
> It is _known_ that you need to be running btrfs-progs 3.17 to repair the
> read-only snapshot that are borked up, and that you must _not_ have
> previously tried to repair the problme with an older btrfsck.

No, I didn't try to repair it with older kernels/btrfs-tools.

>
> Were I you, I would...
>
> Put the two disks back in the same computer before something bad happens.
>
> Upgrade that computer to 3.17.2 and 3.17 respectively.

As I mentioned before I only have two slots and my system on this
btrfs-raid1 is not working anymore. Not just when accessing
ro-snapshots - it crashes everytime at the login prompt. So now I
installed Ubuntu 14.04 to an USB stick (so I can readd both btrfs
HDDs) and upgraded the kernel to 3.17.2 and btrfs-tools to 3.17.

>
> Take a backup (because I am paranoid like that, though current threat seems
> negligible).

I already have a backup. :)

>
> btrfsck your raid with --repair.

OK. And this is what I get now:

tobby@ubuntu: sudo btrfs check /dev/sda1
root item for root 1746, current bytenr 80450240512, current gen
163697, current level 2, new bytenr 40074067968, new gen 163707, new
level 2
Found 1 roots with an outdated root item.
Please run a filesystem check with the option --repair to fix them.

tobby@ubuntu: sudo btrfs check /dev/sda1 --repair
enabling repair mode
fixing root item for root 1746, current bytenr 80450240512, current
gen 163697, current level 2, new bytenr 40074067968, new gen 163707,
new level 2
Fixed 1 roots.
Checking filesystem on /dev/sda1
UUID: 3ad065be-2525-4547-87d3-0e195497f9cf
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 18446744073709551607 inode 258 errors 1000, some csum missing
found 36031450184 bytes used err is 1
total csum bytes: 59665716
total tree bytes: 3523330048
total fs tree bytes: 3234054144
total extent tree bytes: 202358784
btree space waste bytes: 755547262
file data blocks allocated: 122274091008
 referenced 211741990912
Btrfs v3.17

>
> Alternately, if you previously tried to btrfsck the raid with a version
> prior to 3.17 tools after the read-only snapshot(s) problem, you will need
> to resort to mkfs.btrfs to solve the problem. But Hey! you have two disks,
> so break the RAID, then mkfs one of them, then copy the data, then re-make
> the RAID such that the new FS rules.
>
> Enjoy your system no longer taking racy read-only snapshots... 8-)
>
>

Aaaaand this worked! :) Server is back online without restoring any
files from the backup. Looks good to me!

But I can't do a balance anymore?

root@t-mon:~# btrfs balance start /dev/sda1
ERROR: can't access '/dev/sda1'

Regards
Tobias
