Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55230 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751313AbcL1Luk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Dec 2016 06:50:40 -0500
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Rene Wolf <igeligel@gmx.net>
Subject: Incremental send receive of snapshot fails
Message-ID: <1d9e30d3-f34d-9293-8150-b48f8be33bca@gmx.net>
Date: Wed, 28 Dec 2016 12:50:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all


I have a problem with incremental snapshot send receive in btrfs. May be 
my google-fu is weak, but I couldn't find any pointers, so here goes.


A few words about my setup first:

I have multiple clients that back up to a central server. All clients 
(and the server) are running a (K)Ubuntu 16.10 64Bit on btrfs. Backing 
up works with btrfs send / receive, either full or incremental, 
depending on whats available on the server side. All clients have the 
usual (Ubuntu) btrfs layout: 2 subvolumes, one for / and one for /home; 
explicit entries in fstab; root volume not mounted anywhere. For further 
details see the P.s. at the end.


Here's what happens:

In general I stick to the example form 
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup . Backing up 
is done daily by a script, and it works successfully on all of my 
clients except one (called "lab").

I start with the first snapshot on "lab" and do a full send to the 
server. This works as expected (sending takes some hours as it is done 
over wifi+ssh). After that is done I send an incremental snapshot based 
on the previous parent. This also works as expected (no error etc). 
Sending deltas then happens once a day, with the script always keeping 
the last two snapshots on the client and many more on the server. Also 
after each run of the script I do a bit of "house keeping" to prevent 
"disk full" etc (see below p.s. for commands).

I can't exactly say when, but after some time (possibly the next day) 
snapshot sending fails with an error on the receiving end:
ERROR: unlink some/file failed. No such file or directory

Some searching around lead me to this 
https://bugzilla.kernel.org/show_bug.cgi?id=60673 . So I checked to make 
sure my script doesn't use the wrong parent; and it does not. But to 
make really sure I tried a send / receive directly on "lab" without the 
server:

# btrfs subvol snap -r / /.back/new_snap
> Create a readonly snapshot of '/' in '/.back/new_snap'

# btrfs subv show /.back/last_snap_by_script
> /.back/last_snap_by_script
>         Name:                   last_snap_by_script
>         UUID:                   b4634a8b-b74b-154a-9f17-1115f6d07524
>         Parent UUID:            b5f9a301-69f7-0646-8cf1-ba29e0c24fac
>         Received UUID:          196a0866-cd05-d24e-bac6-84e8e5eb037a
>         Creation time:          2016-12-27 17:55:10 +0100
>         Subvolume ID:           486
>         Generation:             52036
>         Gen at creation:        51524
>         Parent ID:              257
>         Top level ID:           257
>         Flags:                  readonly
>         Snapshot(s):

# btrfs subv show /.back/new_snap
> /.back/new_snap
>         Name:                   new_snap
>         UUID:                   fca51929-8101-db45-8df6-f25935c04f98
>         Parent UUID:            b5f9a301-69f7-0646-8cf1-ba29e0c24fac
>         Received UUID:          196a0866-cd05-d24e-bac6-84e8e5eb037a
>         Creation time:          2016-12-28 11:51:43 +0100
>         Subvolume ID:           506
>         Generation:             52271
>         Gen at creation:        52271
>         Parent ID:              257
>         Top level ID:           257
>         Flags:                  readonly
>         Snapshot(s):

# btrfs send -p /.back/last_snap_by_script /.back/new_snap > delta
> At subvol /.back/new_snap

# btrfs subvol del /.back/new_snap
> Delete subvolume (no-commit): '/.back/new_snap'

# cat delta | btrfs receive /.back/
> At snapshot new_snap
> ERROR: unlink some/file failed. No such file or directory

And the receive always fails with some ERROR similar to the above! What 
I find a bit odd is the identical "Received UUID", even before new_snap 
was sent / received ... but maybe that's normal?

If instead of "last_snap_by_script" I also create a new read only 
snapshot and send the delta between these two "new" ones, everything 
works as expected. But then there's little differences between the two 
new snaps ...

I tried to look for differences between the "lab" client and another one 
("navi") where backing up works. So far I couldn't really find anything. 
I did create both file systems at different points in time (possibly 
with different kernels). All fs were created as btrfs and not 
"converted" from ext. "lab" has an SSD, "navi" a spinning disc. Both 
systems run on Intel CPUs in 64Bit ...


So now I have a snapshot on "lab" which I cannot use as a parent, but 
why? What did I do wrong? The whole procedure does work on my other 
clients (with the exact same script), why not on the "lab" client? And 
this is a re-occuring problem: I tried deleting all of the snaps (on 
both ends) and start all over again ... it will again end up with a 
"broken" snapshot eventually.


Up until now using btrfs has been a great experience and I always could 
resolve my troubles quite quickly, but this time I don't know what to do?
Thanks in advance for any suggestions and feel free to ask for other / 
missing details :-)


Regards
Rene


P.s.: here's my system info from the failing client "lab"

$ uname -a
Linux lab 4.8.0-32-generic #34-Ubuntu SMP Tue Dec 13 14:30:43 UTC 2016 
x86_64 x86_64 x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.7.3

# btrfs fi show
Label: 'SSD'  uuid: 122ecca7-9804-4c8a-b4ed-42fd6c6bbe7a
         Total devices 1 FS bytes used 37.62GiB
         devid    1 size 55.90GiB used 41.03GiB path /dev/sdb1

# btrfs fi df /
Data, single: total=40.00GiB, used=37.09GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=1.00GiB, used=543.08MiB
GlobalReserve, single: total=112.38MiB, used=0.00B

$ mount | grep btrfs
/dev/sdb1 on / type btrfs 
(rw,noatime,ssd,space_cache,subvolid=257,subvol=/@)
/dev/sdb1 on /home type btrfs 
(rw,noatime,ssd,space_cache,subvolid=286,subvol=/@home)

# btrfs scrub start -B /
scrub done for 122ecca7-9804-4c8a-b4ed-42fd6c6bbe7a
         scrub started at Wed Dec 28 12:05:53 2016 and finished after 
00:02:24
         total bytes scrubbed: 37.76GiB with 0 errors

"house keeping" mostly based on suggestions from Marc's Blog 
(http://marc.merlins.org/perso/btrfs/)
# /bin/btrfs balance start -v -dusage=0 /
# /bin/btrfs balance start -v -dusage=60 -musage=60 -v /

I can add a dmesg output on request, but so far I couldn't observe any 
reaction there...
