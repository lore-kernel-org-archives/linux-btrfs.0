Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:39366 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753079AbeAAToo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jan 2018 14:44:44 -0500
Received: by mail-it0-f43.google.com with SMTP id 68so37573705ite.4
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jan 2018 11:44:44 -0800 (PST)
MIME-Version: 1.0
Reply-To: swestrup@gmail.com
In-Reply-To: <1clphe-a7q.ln1@hurikhan77.spdns.de>
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com>
 <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com> <1clphe-a7q.ln1@hurikhan77.spdns.de>
From: Stirling Westrup <swestrup@gmail.com>
Date: Mon, 1 Jan 2018 14:44:43 -0500
Message-ID: <CAJt7KB-sq0sxHe_3LSC5kzU0CG8ABk4baDnGP138vNaLK0KN-Q@mail.gmail.com>
Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 1, 2018 at 7:15 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Mon, 01 Jan 2018 18:13:10 +0800 schrieb Qu Wenruo:
>
>> On 2018年01月01日 08:48, Stirling Westrup wrote:
>>>
>>> 1) I had a 2T drive die with exactly 3 hard-sector errors and those 3
>>> errors exactly coincided with the 3 super-blocks on the drive.
>>
>> WTF, why all these corruption all happens at btrfs super blocks?!
>>
>> What a coincident.
>
> Maybe it's a hybrid drive with flash? Or something that went wrong in the
> drive-internal cache memory the very time when superblocks where updated?
>
> I bet that the sectors aren't really broken, just the on-disk checksum
> didn't match the sector. I remember such things happening to me more than
> once back in the days when drives where still connected by molex power
> connectors. Those connectors started to get loose over time, due to
> thermals or repeated disconnect and connect. That is, drives sometimes
> started to no longer have a reliable power source which let to all sorts
> of very strange problems, mostly resulting in pseudo-defective sectors.
>
> That said, the OP would like to check the power supply after this
> coincidence... Maybe it's aging and no longer able to support all four
> drives, CPU, GPU and stuff with stable power.

You may be right about the cause of the error being a power-supply issue.
For those that are curious, the drive that failed was a Seagate Barracuda
LP 2000G drive (ST2000DL003).

I hadn't gone into the particulars of the failure, but the BTRFS in
question is my
file server and it mostly holds ripped DVDs, so the storage tends to
grow in size
but existing files seldom change, unless I reorganize things. The
intent is for it to
be backed up to a proper RAIDed BTRFS system weekly, but I have to admit that
I've never gotten around to automating the start of backups and have just been
running it whenever I make large changes to the file server, or
reorganize things.

I was starting to run out of space on the file server, and I had
noticed a few transient
drive errors in the logs (from the 2T device that failed) and so had
decided I'd add
another 2T device to the array temporarily, and then replace both the
failing device and the
temp device with a new 4T drive once I'd had a chance to go buy a new one.

In hind sight (which is always 20/20), I should have updated the
backups before starting to
make my changes, but as I'd just added a new 4T drive to the BTRFS
RAID6 in my backup
system a week before, and it went as smooth as butter, I guess I was
feeling insufficiently
paranoid.

I shut down the system, installed the 5th drive, rebooted... and
nothing. The system made some
horrible sounds and refused to boot. It wouldn't even get past POST.
Not being a hardware
guy I wasn't sure what killed my server box, but I assume it was the
power supply. Again, once
I get the chance I'll take it to my local computer shop and have
someone look at it.

Luckily I had an exactly identical system laying idle, so I swapped
all the drives and the extra sata
controller to handle them, and booted it up, only to find that the
failing drive had now definitely failed.

Interesting, the various tools I used kept reporting an 'unknown
error' for the 3 bad sectors. IIRC, one
of the diagnostic tools reported it as "Error 11 (Unknown)". In any
case, there appeared to be many
errors on the disk, but when I used ddrescue to make a full copy of
it, all of the sectors were (eventually)
fully recovered, except for the 3 superblocks.

After a few days of non-destructive tests and googling for information
on BTRFS multi-drive systems, I
finally decided I had to contact this list for advice, and the rest is
well documented.
