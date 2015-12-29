Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33316 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbL2AIM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 19:08:12 -0500
Received: by mail-ob0-f178.google.com with SMTP id bx1so124628964obb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 16:08:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451188888.6446.18.camel@scientia.net>
References: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com>
	<pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
	<1451188888.6446.18.camel@scientia.net>
Date: Mon, 28 Dec 2015 18:08:12 -0600
Message-ID: <CACRRrm-MteDcXSg10npqHLA6ZzGHfDM-ByxyvR19npaNuS3t-A@mail.gmail.com>
Subject: Re: Btrfs Check - "type mismatch with chunk"
From: Zach Fuller <conicawd@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        covici@ccs.covici.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for helping me out. Here's an update on my system.

> How long have you had the filesystem?  Was it likely created with the mkfs.btrfs from btrfs-progs v4.1.1 (July, 2015) as I suspect?
Unfortunately, I do not remember exactly when I created the
filesystem, but I know that it was created either on May 2015 or
before then. I have been using the standard main branch for the
btrfs-progs. WHen I created the btrfs filesystem, I first wiped the
entire drive, created a new GPT on the drive, created a single
partition, and then created the btrfs filesystem on that partition. I
did not convert an ext* filesystem to btrfs. The hard drive model
number is "ST2000DL003-9VT166". I had to do some manual make the drive
use 4K sectors when I set it up because it reported 512 bytes even
though it actually supported 4k. I followed these instructions to do
so (https://wiki.archlinux.org/index.php/Advanced_Format)



I have grabbed the "btrfs-progs-git" package from the AUR, which
should contain the devel branch.
$ sudo btrfs --version
btrfs-progs v4.3.1-31-g0ab3d31

I ran "btrfs check --repair" again on the drive, and no "type mismatch
with chunk" errors were returned.


$ sudo btrfs check --repair /dev/sdc1 2>&1 | tee repair.txt
checking extents
Fixed 0 roots.
checking free space cache
checking fs roots
checking csums
checking root refs
enabling repair mode
Checking filesystem on /dev/sdc1
UUID: 1a160f37-7206-43f9-9285-6217ee97a665
cache and super generation don't match, space cache will be invalidated
found 1681690084900 bytes used err is 0
total csum bytes: 1639800688
total tree bytes: 2534178816
total fs tree bytes: 390807552
total extent tree bytes: 142917632
btree space waste bytes: 438755239
file data blocks allocated


I then mounted the drive, ran "du -s", unmounted the drive again, and
ran "btrfs check" one more time to see if any errors remained:


$ sudo btrfs check  /dev/sdc1 2>&1 | tee check2.txt
checking extents
checking free space cache
Wanted bytes 737280, found 1245184 for off 5683961462784
Wanted bytes 536870912, found 1245184 for off 5683961462784
cache appears valid but isnt 5683961462784
Checking filesystem on /dev/sdc1
UUID: 1a160f37-7206-43f9-9285-6217ee97a665
found 1681690084900 bytes used err is -22
total csum bytes: 1639800688
total tree bytes: 2534178816
total fs tree bytes: 390807552
total extent tree bytes: 142917632
btree space waste bytes: 438755239
file data blocks allocated: 1802146615296
 referenced 1782959542272


I'm not sure what the output of the above check means, but there are
certainly less errors than before. Should I be worried about these
"free space cache" errors?

It seems that the newer version of "btrfs-progs" from the devel branch
fixed the problem. The drive still mounts and functions correctly.
Should I continue to run the devel branch, or should I switch back to
the main branch? I would prefer to have a stable system rather than
being on the bleeding edge.

On Sat, Dec 26, 2015 at 10:01 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Thu, 2015-12-24 at 23:41 +0000, Duncan wrote:
>> as the patch is in the userspace  4.3.1 you're running.
> I don't think this is the case.
>
> The commit was b08a740d7b797d870cbc3691b1291290d0815998 and AFAICT,
> it's not included in any release yet.
>
> 4.3.1 was from Nov 16th, the above commit was from the 26th.
>
>
> As I've said before, please try with the patch applied (it's in the
> devel branch only).
>
>
> Cheers,
> Chris.
