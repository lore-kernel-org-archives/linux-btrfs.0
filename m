Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.myhostedservice.com ([66.129.85.153]:29988 "EHLO
	smtp02.myhostedservice.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932630AbaJUNlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 09:41:19 -0400
Received: from EWGW01 (unknown [172.29.211.221])
	by smtp02.myhostedservice.com (Halon Mail Gateway) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 09:41:03 -0400 (EDT)
Subject: Re: Re: BTRFS with more than two parities
MIME-Version: 1.0
Received: from securemessage.myhostedservice.com ([172.29.211.220])
          by EWGW01 (JAMES SMTP Server 2.3.2) with SMTP ID 706
          for <linux-btrfs@vger.kernel.org>;
          Tue, 21 Oct 2014 09:40:38 -0400 (EDT)
From: Ronny Egner <ronnyegner@ronnyegner-consulting.de>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 21 Oct 2014 13:41:03 +0000
Message-ID: <D06C2F07.4026B%ronnyegner@ronnyegner-consulting.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Tue, 21 Oct 2014 11:01:50 as excepted:

>>Ronny Egner posted on Tue, 21 Oct 2014 06:28:34 +0000 as excerpted:
>> Dear All,
>> i was wondering what happened with the patch posted by Andrea Mazzoleni
>> back in Februrary 2014 (this Thread:
>> http://thread.gmane.org/gmane.linux.kernel/1654735)
>> Why washÂ´t it added to the code? Something missing/wrong
>> In my opinion the posted patch is awesome and would enable a unique
>> feature to btrfs that no file system / volume manager on Linux and other
>>UNIX-operating system currently has.

> That, along with a bunch of other features, is on the longer term
> roadmap and will likely eventually be implemented.  Actually, the
> discussion involves a quite flexible plan where number of
> redundancies/parities/strips-per-strip are all configurable along
> different/independent axes.

> I wouldn't recommend expecting it any time soon, however, as btrfs
> features have repeatedly taken far longer to implement and become stable
> than originally predicted.

Understood. But what is the point in having a file system / volume manager
combination if you donÂ´t offer the required redundancy levels? And that
included parity with more than one or two disks for me. Or parity-based
redundancy *at all* given the current status of the raid56 implementation.

Mirroring is not the solution to everything. Many use cases include the
need
for many disks and a lot of space. And parity-based is definitely needed
right
from the start imho.


> Altho certainly the devs haven't been idle.  /Tremendous/ progress has
> been made in general btrfs stability in that time.  It's just that,
>well, 
> stability /did/ become the overriding focus, and in that time, btrfs has
> gone from a definitely experimental filesystem that could and did often
> eat data, to one that's still not entirely stable and where backups for
> data of any value are still strongly recommended, but that works pretty
> well, most of the time for most users, including not only the
>traditional 
> filesystem features, but even most of the existing non-traditional
> features that are (nearly) btrfs specific.

Yes, btrfs was (not sure what the status in later kernels 3.17 and 3.18 is)
not very stable. Stability certainly has priority.



> FWIW, the other, more mature but not fully GPLv2 kernel license
> compatible alternative is Sun/Oracle's ZFS.  It's a mature filesystem
> with many promised btrfs features already implemented and long mature,
> but choosing it does mean either choosing a non-mainline kernel module
> with questionable legal issues (or the slower userspace code), or
> choosing a kernel other than Linux -- one of the implementing BSDs or
> Solaris.  That's the most viable current option for some would-be btrfs
> users, tho it's not so viable for others, for various reasons.

I played with it. It has a rock solid parity implementation but some other
downsides like the requirement for ECC memory, large memory footprint,
sub-optimal interaction with the linux memory management, I/O
characteristics
due to the nature of RAIDZ (all number of I/Os in a raid group (called
â€švddvâ€˜)
is exactly the number of I/O one disk is able to do - regardless of the
number
of disks in the vdev), and so on.

> The other more general raid solution would be to get the n-way-parity
> code into the kernel's md- or dmraid implementations.  I've no idea what
> the status is there, but presumably they're considering it, and given
> btrfs implementation timetables, they may well have it implemented and
> stable long before btrfs does.

IÂ´ve asked on the kernel mailing list as well since it would be a waste
to throw this not entirely simple work away.

(When replying please send me the mail CC. Thanks)


Ronny

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
