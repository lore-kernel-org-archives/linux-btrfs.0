Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:35896 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcF1VwP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 17:52:15 -0400
Received: by mail-vk0-f50.google.com with SMTP id k62so31135229vkb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 14:52:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0fe98668-5448-91c6-964d-4b9ab877668b@fastmail.fm>
References: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
 <CAJCQCtRrk70p+iNNKCZvmz4T3R2=2d_JqQXJuSpt2QD1g9ysZQ@mail.gmail.com>
 <feb87fbf-c017-ce29-3ba5-abc9d4cbb303@fastmail.fm> <CAJCQCtSdNitRUA498COj1S3bcgdVA8Xf6qq1Fw71pbn_m=Z62A@mail.gmail.com>
 <CAPmG0jbhv8tL4wOimNuAYKv+BruZy=JfzjjhjnEg6nbF5A+1_g@mail.gmail.com> <0fe98668-5448-91c6-964d-4b9ab877668b@fastmail.fm>
From: Henk Slager <eye1tm@gmail.com>
Date: Tue, 28 Jun 2016 23:52:13 +0200
Message-ID: <CAPmG0ja3L7dgbAUsZwN-V4AdyMuO4cQcHsqKScfR6KCnxYnmcg@mail.gmail.com>
Subject: Re: Btrfs full balance command fails due to ENOSPC (bug 121071)
To: Francesco Turco <fturco@fastmail.fm>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2016 at 3:46 PM, Francesco Turco <fturco@fastmail.fm> wrote:
> On 2016-06-27 23:26, Henk Slager wrote:
>> btrfs-debug does not show metadata ans system chunks; the balancing
>> problem might come from those.
>> This script does show all chunks:
>> https://github.com/knorrie/btrfs-heatmap/blob/master/show_usage.py
>>
>> You might want to use vrange or drange balance filters so that you can
>> just target a certain chunk and maybe that gives a hint where the
>> problem might be. But anyhow, the behavior experienced is a bug.
>
> Updated the bug with the output log from your script. I simply ran it as:
>
> ./show_usage.py /
>
> I don't know how to use vrange/drange balance filters. Can you show me
> how to do that, please?

The original dmesg log shows that balance gets into trouble at block group
46435139584. This is SYSTEM|DUP and in the later blockgroup list
generated with Hans' py script it is not there anymore under this same
vaddr, so btrfs (or new manual balance) has managed to relocate it,
despite the enospc.

One theory I once had is that at the beginning of the disk, there were
or are small chunks of 8MiB, whereas the rest of the disk has 1G or at
least bigger chunks once the fs gets used and filled up. Those initial
small chunks tend to be system and/or metadata. If then later after
heavy use of a full balance the small chunks get relocated, there is
then unallocated space, but virtually nothing fits there if the policy
is 'first allocate big chunks'. So here the allocater mechanism could
then output an enospc, assuming that it
doesn't try exhaustively in order to keep the code simple and fast.
But it is only theory, one would need to traceback etc in such a case.
I never had such a case, so I can't prove it.

Suppose you want to relocate the metadata blockgroup (you have only
one, it is the same location in the 2 lists from the bug report)

btrfs balance start -v -mvrange=29360128..29360129 /

This 1-byte range in in the virtual adress range 29360128 ..
29360128+1G-1,[ so it will relocate the metadata blockgroup. After
succesfull balance, you will see its vaddr increased and its device
addresses (paddr) also changed.

If you want to balance based on device address and for example
relocate just 1 of the dup of the metadata:
btrfs balance start -v -mdevid=1,drange=37748736..37748737 /

All this does not solve the bug, but hopefully gives us better
understanding in cases where balance also fails and also no file
creation is possible anymore.



>
> --
> Website: http://www.fturco.net/
> GPG key: 6712 2364 B2FE 30E1 4791 EB82 7BB1 1F53 29DE CD34
