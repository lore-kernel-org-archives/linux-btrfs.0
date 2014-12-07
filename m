Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:59857 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752220AbaLGTjK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 14:39:10 -0500
Message-ID: <11f1f0272aa7bda76f07ead45ad415ab.squirrel@webmail.wanet.net>
In-Reply-To: <20141207183444.GA1442@carfax.org.uk>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
    <44320137.fRRuR6EFMP@merkaba>
    <88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net>
    <20141207183444.GA1442@carfax.org.uk>
Date: Sun, 7 Dec 2014 11:39:09 -0800
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: ashford@whisperpc.com
To: "Hugo Mills" <hugo@carfax.org.uk>, ashford@whisperpc.com,
        "Martin Steigerwald" <Martin@lichtvoll.de>,
        "Shriramana Sharma" <samjnaa@gmail.com>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Sun, Dec 07, 2014 at 10:20:27AM -0800, ashford@whisperpc.com wrote:
> [snip]
>> > 3) From what I gathered it is planned to allow different raid /
>> > redundancy levels for different subvolumes. BTRFS can´t know
>> > beforehand where applications request to save future data, i.e.
>> > in which subvolume.
>>
>> Same as above.
>>
>> If a user will be requesting to use a specific subvolume, it is up to
>> them
>> to verify that adequate free space exists there, or handle the
>> exception.
>
>    OK, so let's say I've got a filesystem with 100 GiB of unallocated
> space. I have two subvolumes, one configured for RAID-1 and one
> configured for single storage.
>
>    What number should be shown in the free output of df?
>
>    100 GiB? But I can only write 50 GiB to the RAID-1 subvolume before
> it runs out of space.
>
>    50 GiB? I can get twice that much on the single subvolume.
>
>    *Any* value shown here is going to be inaccurate, and whatever way
> round we show it, someone will complain.

As an example, let's assume that the file-system is mounted as /data, with
a non-mirrored subvolume of /data/1 and a mirrored subvolume of /data/2. 
A df should should 100GiB free in both /data and /data/1, and 50GiB free
in /data/2.

Peter Ashford

