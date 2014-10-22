Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:57331 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbaJVBK2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 21:10:28 -0400
Message-ID: <54470403.8020904@pobox.com>
Date: Tue, 21 Oct 2014 18:10:27 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Arnaud Kapp <kapp.arno@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 5 _thousand_ snapshots? even 160? (was: device balance times)
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl> <5446C597.9080904@gmail.com>
In-Reply-To: <5446C597.9080904@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's an unmanageably large and probably pointless number of snapshots 
guys.

I mean 150 is a heck of a lot, and 5000 is almost unfathomable in terms 
of possible usefulness.

Snapshots are cheap but they aren't free.

Each snapshot is effectively stapling down one version of your entire 
metadata tree, right? So imagine leaving tape spikes (little marks on 
the floor to keep track of where something is so you can put it back) 
for the last 150 or 5000 positions of the chair you are sitting in. At 
some point the clarity and purpose of those marks becomes the opposite 
of useful.

Hourly for a day, daily for a week, weekly for a month, monthly for a 
year. And it's not a "backup" if you haven't moved it to another device. 
If you have 5k snapshots of a file that didn't change, you are still 
just one bad disk sector away from never having that data again because 
there's only one copy of the actual data stapled down in all of those 
snapshots.

The ability to avoid fragmentation and cruft is diminished by excessive 
snapshots on a live media.

Go get a backup drive or whatever. Snapshot you live media, send the 
snapshot to that backup. If you want to hoard them, hoard them on the 
backup drive.

There is an old saying. If you haven't run the restore operation your 
backup scheme is untested. Have you _really_ considered how you would go 
about scavenging through 5k of snapshots? Have you really done the 
exercise-of-consideration about what you are safeguarding by having 156 
or more paths to the same single disk sector?

More than four snapshots on the live disk and you are playing with it 
(ha ha).

Excessive snapshotting _will_ complicate many operations because you are 
permuting the choices the system has to consider and you are leaving 
allocated the ghosts of long dead files (like old logs in /var/log and 
umpteen copies of your browser cookies and history, and copies of the 
window layout from the last several hundred times you logged out of your 
desktop).


I don't think balance will _ever_ move the contents of a read only 
snapshot. I could be wrong. I think you just end up with an endlessly 
fragmented storage space and balance has to take each chunk and search 
for someplace else it might better fit. Which explains why it took so long.

And just _forget_ single-extent large files at that point.

(Of course I could be wrong about the "never move" rule, but that would 
just make the checksums on the potentially hundreds or thousands of 
references need to be recalculated after a move, which would make 
incremental send/receive unfathomable.)


On 10/21/2014 01:44 PM, Arnaud Kapp wrote:
> Hello,
>
> I would like to ask if the balance time is related to the number of
> snapshot or if this is related only to data (or both).
>
> I currently have about 4TB of data and around 5k snapshots. I'm thinking
> of going raid1 instead of single. From the numbers I see this seems
> totally impossible as it would take *way* too long.
>
> Would destroying snapshots (those are hourly snapshots to prevent stupid
> error to happens, like `rm my_important_file`) help?
>
> Should I reconsider moving to raid1 because of the time it would take?
>
> Sorry if I'm somehow hijacking this thread, but it seemed related :)
>
> Thanks,
>
> On 10/21/2014 10:14 PM, Piotr Pawłow wrote:
>> On 21.10.2014 20:59, Tomasz Chmielewski wrote:
>>> FYI - after a failed disk and replacing it I've run a balance; it took
>>> almost 3 weeks to complete, for 120 GBs of data:
>>
>> Looks normal to me. Last time I started a balance after adding 6th
>> device to my FS, it took 4 days to move 25GBs of data. Some chunks took
>> 20 hours to move. I currently have 156 snapshots on this FS (nightly
>> rsync backups).
>>
>> I think it is so slow, because it's disassembling chunks piece by piece
>> and stuffing these pieces elsewhere, instead of moving chunks as a
>> whole. If you have a lot of little pieces (as I do), it will take a
>> while...
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

