Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:38939 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaK2VPM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 16:15:12 -0500
Received: by mail-yk0-f169.google.com with SMTP id 79so3785558ykr.28
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 13:15:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547981BB.7030206@pobox.com>
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com>
	<20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it>
	<20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it>
	<20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net>
	<54764F4E.80405@pobox.com>
	<pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>
	<CAJCQCtSGT_CCYZ5WBo_xqw5xWgFbovoWca0-yBEk5WiR7PYQwg@mail.gmail.com>
	<pan$40148$39c282ee$365818$9e1ebdba@cox.net>
	<547981BB.7030206@pobox.com>
Date: Sat, 29 Nov 2014 14:15:11 -0700
Message-ID: <CAJCQCtSDsHOSziCix7Rsy1oUH=dpbHVy4m4OHSV3tkS4e7wH6g@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
To: Robert White <rwhite@pobox.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 29, 2014 at 1:20 AM, Robert White <rwhite@pobox.com> wrote:
> On 11/28/2014 11:29 PM, Duncan wrote:
>>
>> Since I can't/won't run pretty much anything proprietary, there's little
>> chance of it being taken as anything but Linux, here.  (Tho I actually
>> use (c)gdisk for partitioning here and it appears to use a different GUID.
>> (0700 in its short form which AFAIK is gdisk specific, for MS basic data,
>> while it uses 8300 for general Linux filesystems.  I could look up the
>> long form GUIDs, but meh...)
>
>
> Partition type codes (e.g. 0700, 8300, EF00, etc) have _nothing_ to do with
> UUIDs. They are type codes. They aren't "short form" of anything else at
> all. In fact 0700 is the _long_ _form_ of the original code of "7", but in
> big-endian order now that it went from one byte to two.

No that's not correct. These four digit type codes are a user facing
friendly type code, the actual on-disk "partitiontype GUID" is a UUID
in that at the time of creation that UUID followed RFC 4122 so it was
unique: no one else was using the UUID. That UUID in the context of a
partitiontype GUID is intended to describe the purpose of that
partition: what OS, what file system, where it should mount or be used
for, etc. This is elaborately detailed in the GPT (GUID partition
table) portion of the UEFI specification. A 120 bit type code is
rather difficult for humans to remember and interact with, hence gdisk
and recently fdisk now use a four digit type code as a front end for
the partitiontypeGUID. The selection of four digits was to account for
the fact there are many many many more type codes now possible,
essentially unlimited.

This is a case where UUID are reused effectively.



> Microsoft started using pre-assigned UUIDs as "classes", e.g. type codes
> they could cram into their various registry files. If you actually read the
> registry you'll find a lot of places where "rational word" is defined as
> {some_uuid_here} and then eslwere {some_uuid_here} has a bunch of data items
> attached to it.
>
> So gpartd didn;t "reuse" microsoft UUIDs.

GNU parted absolutely re-used partitiontypeGUID
EBD0A0A2-B9E5-4433-87C0-68B6B72699C for Linux, by default. This you
know as gdisk (and friends) type code 0700. It's the same thing as
using type code 07 on an MBR partitioned disk instead of 83. It's
ridiculous that this happened considering we had distinction on MBR
with limited type code availability, and on GPT with unlimited type
codes the decision was to use an already existing type code,
EBD0A0A2-B9E5-4433-87C0-68B6B72699C.

http://www.rodsbooks.com/linux-fs-code/

The Linux partitiontype GUID is now
0FC63DAF-8483-4772-8E79-3D69D8477DE4. And actually some others have
been created also for encryption, RAID, LVM, swap, and a pile of GUIDs
from the 'discoverable partitions spec' hosted at freedesktop.org for
autodiscovery by systemd. Only very recent versions of parted supports
code 0FC63DAF-8483-4772-8E79-3D69D8477DE4.


> All this stuff has historical reasons. GNU/Linux attempts to be an
> egalitarian actor so it adapts to whatever you do.

With respect to this particular reuse of a Windows type code, it did a
total face plant on adaptation. The very decision to reuse that GUID
was a huge, weird mistake that we'll live with for years to come. Data
loss will result from it. And then it was made worse, upon recognition
that the conflict was probably not a good idea, to undermine patching
GNU parted in a timely manner. The patch to fix the problem, from the
gdisk author, sat around for two years before parted upstream merged
it. There really isn't good diplomatic language to use for this. Some
people flat out dropped the ball, and just didn't give a crap.

-- 
Chris Murphy
