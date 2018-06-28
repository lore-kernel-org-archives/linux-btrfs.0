Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:46152 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935019AbeF1W1p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 18:27:45 -0400
Received: by mail-ot0-f176.google.com with SMTP id v24-v6so7882754otk.13
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 15:27:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <93a74ac2-c271-accd-d0c7-4822c0f75f80@libero.it>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com> <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
 <93a74ac2-c271-accd-d0c7-4822c0f75f80@libero.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 28 Jun 2018 16:27:44 -0600
Message-ID: <CAJCQCtRUgoQPNwcM54hXnNSqcm5+0d9Ks1aWw_2VYChMxWWnEg@mail.gmail.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>, Anand Jain <anand.jain@oracle.com>,
        Remi Gauvin <remi@georgianit.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 28, 2018 at 11:37 AM, Goffredo Baroncelli
<kreijack@libero.it> wrote:

> Regarding your point 3), it must be point out that in case of NOCOW files, even having the same transid it is not enough. It still be possible that a copy is update before a power failure preventing the super-block update.
> I think that the only way to prevent it to happens is:
>   1) using a data journal (which means that each data is copied two times)
> OR
>   2) using a cow filesystem (with cow enabled of course !)


There is no power failure in this example. So it's really off the
table considering whether Btrfs or mdadm/lvm raid do better in the
same situation with a nodatacow file.

I think here is the problem in the Btrfs nodatacow case. Btrfs doesn't
have a way of untrusting nodatacow files on a previously missing drive
that hasn't been balanced. There is no such thing as nometadatacow, so
no matter what it figures out there's a problem, and uses the good
copy of metadata, but it never "marks" the previously missing device
as suspicious. When it comes time to read a nodatacow file, Btrfs just
blindly reads off one of the drives, it has no mechanism for
questioning the formerly missing drive without csum.

That is actually a really weird and unique kind of write hole for
Btrfs raid1 when the data is nodatacow.

I have to agree with Remi. This is a flaw in the design or bad bug,
however you want to consider it. Because mdadm/lvm do not behave this
way in the exact same situation.

And an open question I have about scrub is weather it only ever is
checking csums, meaning nodatacow files are never scrubbed, or if the
copies are at least compared to each other?

As for fixes:

- During mount time, Btrfs sees from supers that there is a transid
mismatch, to not read nodatacow files from the lower transid device
until an auto balance has completed. Right now Btrfs doesn't have an
abbreviated balance that "replays" the events between two transids.
Basically it would work like send/receive but for balance to catch up
a previously missing device. Right now we have to do a full balance
which is a brutal penalty for a briefly missing drive. Again, mdadm
and lvm do better here by default.

- Fix the performance issues of COW with disk images. ZFS doesn't even
have a nodatacow option and they're running VM images on ZFS and it
doesn't sound like they're running into ridiculous performance
penalties that makes it impractical to use.



-- 
Chris Murphy
