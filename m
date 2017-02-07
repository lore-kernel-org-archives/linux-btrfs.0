Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:37372 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754472AbdBGQ2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Feb 2017 11:28:49 -0500
Subject: Re: BTRFS for OLTP Databases
To: Peter Zaitsev <pz@percona.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <3508c89f-f7e4-f5db-5587-ab9e1e758b8b@bouton.name>
Date: Tue, 7 Feb 2017 17:22:20 +0100
MIME-Version: 1.0
In-Reply-To: <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Peter,

Le 07/02/2017 à 15:13, Peter Zaitsev a écrit :
> Hi Hugo,
>
> For the use case I'm looking for I'm interested in having snapshot(s)
> open at all time.  Imagine  for example snapshot being created every
> hour and several of these snapshots  kept at all time providing quick
> recovery points to the state of 1,2,3 hours ago.  In  such case (as I
> think you also describe)  nodatacow  does not provide any advantage.
>
> I have not seen autodefrag helping much but I will try again.     Is
> there any autodefrag documentation available about how is it expected
> to work and if it can be tuned in any way

There's not much that can be done if the same file is modified in 2
different subvolumes (typically the original and a R/W snapshot). You
either break the reflink around the modification to limit the amount of
fragmentation (which will use disk space and write I/O) or get
fragmentation on at least one subvolume (which will add seeks).
So the only options are either to flatten the files (which can be done
incrementally by defragmenting them on both sides when they change) or
only defragment the most used volume (especially if the other is a
relatively short-lived snapshot where performance won't degrade much
until it is removed and won't matter much).

I just modified our defragmenter scheduler to be aware of multiple
subvolumes and support ignoring some of them. The previous version (not
tagged, sorry) was battle tested on a Ceph cluster and was designed for
it. Autodefrag didn't work with Ceph with our workload (latency went
through the roof, OSDs were timing out requests, ...) and our scheduler
with some simple Ceph BTRFS related tunings gave us even better
performance than XFS (which is usually the recommended choice with
current Ceph versions).

The current version is probably still rough around the edges as it is
brand new (most of the work was done last Sunday) and only running on a
backup server with a situation not much different from yours : a large
PostgreSQL slave (>50GB) which is snapshoted hourly and daily, with a
daily snapshot used to start a PostgreSQL instance for "tests on real
data" purposes + a copy of a <10TB NFS server with similar snapshots in
place. All of this is on a single RAID10 13-14TB BTRFS.
In our case using autodefrag on this slowly degraded performance to the
point where off-site backups became slow enough to warrant preventive
measures.
The current scheduler looks for the mountpoints of top BTRFS volumes (so
you have to mount the top volume somewhere), and defragments them avoiding :
- read-only snapshots,
- all data below configurable subdirs (including read-write subvolumes
even if they are mounted elsewhere), see README.md for instructions.

It slowly walks all files eligible for defragmentation and in parallel
detects writes to the same filesystem, including writes to read-write
subvolumes mounted elsewhere to trigger defragmentation. The scheduler
uses an estimated "cost" for each file to prioritize defragmentation
tasks and with default settings tries to keep I/O activity low enough
that it doesn't slow down other tasks too much. However it defragments
files whole, which might put some strain for huge ibdata* files if you
didn't switch to file per table. In our case defragmenting 1GB files is
OK and doesn't have a major impact.

We are already seeing better performance (our total daily backup time is
below worrying levels again) and the scheduler didn't even finish
walking the whole filesystem (there are approximately 8 millions files
and it is configured to evaluate them over a week). This is probably
because it follows the most write-active files (which are in the
PostgreSQL slave directory) and defragmented most of them early.

Note that it is tuned for filesystems using ~2TB 7200rpm drives (there
are some options that will adapt it to subsystems with more I/O
capacity). Using drives with different capacities shouldn't need tuning,
but it probably will not work well on SSD (it should be configured to
speed up significantly).

See https://github.com/jtek/ceph-utils you want btrfs-defrag-scheduler.rb

Some parameters are available (start it with --help). You should
probably start it with --verbose at least until you are comfortable with
it to get a list of which files are defragmented and many debug messages
you probably want to ignore (or you'll probably have to read the Ruby
code to fully understand what they mean).

I don't provide any warranty for it but the worst I believe can happen
is no performance improvements or performance degradation until you stop
it. If you don't blacklist read-write snapshots with the .no-defrag file
(see README.md) defragmentation will probably eat more disk space than
usual. Space usage will go up rapidly during defragmentation if you have
snapshots, it is supposed to go down after all snapshots referring to
fragmented files are removed and replaced by new snapshots (where
fragmentation should be more stable).

Best regards,

Lionel
