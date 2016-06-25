Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33902 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbcFYRO2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 13:14:28 -0400
Received: by mail-oi0-f68.google.com with SMTP id s17so23720843oih.1
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 10:14:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b578050f-1425-134b-9655-7ad36dd4b7ab@crc.id.au>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au> <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au> <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
 <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au> <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
 <c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au> <CAJCQCtRrF-KZOo3HOzNWHwhWcDxFem-tcpGh5ScXoQM2Brosag@mail.gmail.com>
 <b578050f-1425-134b-9655-7ad36dd4b7ab@crc.id.au>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 25 Jun 2016 11:14:27 -0600
Message-ID: <CAJCQCtTYd5x=E8TwqGC-ZcF=EGnF7B_uqnBwrnvUrJp8JXfxXg@mail.gmail.com>
Subject: Re: Trying to rescue my data :(
To: Steven Haigh <netwiz@crc.id.au>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 25, 2016 at 10:39 AM, Steven Haigh <netwiz@crc.id.au> wrote:

> Well, I did end up recovering the data that I cared about. I'm not
> really keen to ride the BTRFS RAID6 train again any time soon :\
>
> I now have the same as I've had for years - md RAID6 with XFS on top of
> it. I'm still copying data back to the array from the various sources I
> had to copy it to so I had enough space to do so.

Just make sure you've got each drive's SCT ERC shorter than the kernel
SCSI command timer for each block device in
/sys/block/device-name/device/timeout or you can very easily end up
with the same if not worse problem which is total array collapse. It's
more rare to see the problem on mdraid6 because the extra parity ends
up papering over the problem caused by this misconfiguration, but it's
a misconfiguration that's the default unless you're using
enterprise/NAS specific drives with short recoveries set on them by
default. The linux-raid@ list is full of problems resulting from this
issue.

I think the obvious mistake here though is assuming reshapes entail no
risk. There's a -f required for a reason. You could have ended up in
just as bad situation doing a reshape without a backup of an md or lvm
based array. Yes it should work, and if it doesn't it's a bug, but how
much data do you want to lose today?



> What I find interesting is that the patterns of corruption in the BTRFS
> RAID6 is quite clustered. I have ~80Gb of MP3s ripped over the years -
> of that, the corruption would take out 3-4 songs in a row, then the next
> 10 albums or so were intact. What made recovery VERY hard, is that it
> got to several situations that just caused a complete system hang.

The data stripe size is 64KiB * (num of disks - 2). So in your case I
think that's 64 *3 = 192KiB. That's less than the size of one song, so
that means roughly 15 bad stripes in a row. That's less than a block
group also.

The Btrfs conversion should be safer than methods used by mdadm and
lvm because the operation is cow. The raid6 block group is supposed to
remain intact and "live" if you will, until the single block group is
written to stable media. The full crash set of kernel messages might
be useful to find out what was happening that instigated all of this
corruption. But even still the subsequent mount should at worst
rollback to state of block groups of different profiles where the most
recent (failed) conversion is still a raid6 block group intact.

So, I'd still say btrfs-image it and host it somewhere, file a bug,
cross reference this thread in the bug, and the bug URL in this
thread. Might take months or even a year before a dev looks at it, but
better than nothing.


>
> I tried it on bare metal - just in case it was a Xen thing, but it hard
> hung the entire machine then. In every case, it was a flurry of csum
> error messages, then instant death. I would have been much happier if
> the file had been skipped or returned as unavailable instead of having
> the entire machine crash.

Of course. The unanswered question though is why are there so many
csum errors? Are these metadata csum errors, or are they EXTENT_CSUM
errors, and how are they becoming wrong? Wrongly read, wrongly
written, wrongly recomputed from parity? How did the parity go bad if
that's the case? So it needs an autopsy or it just doesn't get better.


-- 
Chris Murphy
