Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:33022 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934959AbdACOV4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 09:21:56 -0500
Received: by mail-yw0-f180.google.com with SMTP id r204so289457499ywb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jan 2017 06:21:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9fdde3f9-e2ed-b3d3-a8ec-da6ae27dfe95@oracle.com>
References: <20161206043938.3249-1-anand.jain@oracle.com> <20161212171927.GY12522@twin.jikos.cz>
 <9799c1aa-e365-f05d-2b96-017edc67ec90@oracle.com> <CANznX5FsY==9svvhmRtAG=9_GE5PHYU34B3Hboq-A36GvTf+pg@mail.gmail.com>
 <9fdde3f9-e2ed-b3d3-a8ec-da6ae27dfe95@oracle.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Tue, 3 Jan 2017 15:21:40 +0100
Message-ID: <CANznX5FPg60U252u-1VDJdb6x7j562bMMSCoRJXF4zTrsayy2Q@mail.gmail.com>
Subject: Re: [PATCH] recursive defrag cleanup
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, in order to defrag "everything" in the filesystem (which is
possible to / potentially needs defrag) I need to run:
1: a recursive defrag starting from the root subvolume (to pick up all
the files in all the possible subvolumes and directories)
2: a non-recursive defrag on the root subvolume + (optionally)
additional non-recursive defrag(s) on all the other subvolume(s) (if
any) [but not on all directories like some old scripts did]

In my opinion, the recursive defrag should pick up and operate on all
the subvolumes, including the one specified in the command line (if
it's a subvolume) and all subvolumes "below" it (not on files only).


Does the -t parameter have any meaning/effect on non-recursive (tree)
defrag? I usually go with 32M because t>=128Mb tends to be unduly slow
(it takes a lot of time, even if I try to run it repeatedly on the
same static file several times in a row whereas t<=32M finishes rather
quickly in this case -> could this be a bug or design flaw?).


I have a Btrfs filesystem (among others) on a single HDD with
single,single,single block profiles which is effectively write-only.
Nine concurrent ffmpeg processes write files from real-time video
streams 24/7 (there is no pre-allocation, the files just grow and grow
for an hour until a new one starts). A daily cronjob deletes the old
files every night and starts a recursive defrag on the root subvolume
(there are no other subvolumes, only the default id=5). I appended a
non-recursive defrag to this maintenance script now but I doubt it
does anything meaningful in this case (it finishes very fast, so I
don't think it does too much work). This is the filesystem which
"degrades" in speed for me very fast and needs metadata re-balance
from time to time (I usually do it before every kernel upgrades and
thus reboots in order to avoid a possible localmount rc-script
timeouts).

I know I should probably use a much more simple filesystem (might even
vfat, or ext4 - possibly with the journal disabled) for this kind of
storage but I was curious how Btrfs can handle the job (with CoW
enabled, no less). All in all, everything is fine except the
degradation of metadata performance. Since it's mostly write-only, I
could even skip the file defrags (I originally scheduled it in a hope
it will overcome the metadata slowdown problems and it's also useful
[even if not necessary] to have the files defragmented in case I
occasionally want to use them). I am not sure but I guess defraging
the files helps to reduce the overall metadata size and thus makes the
balance step faster (quick balancing) and more efficient (better
post-balance performance).


I can't remember the exact script but it basically fed every single
directories (not just subvolumes) to the defrag tool using 'find' and
it was meant to complement a separate recursive defrag step. It was
supposed to defrag the metadata (the metadata of every single
directory below the specified location, one by one, so it was very
quick on my video-archive but very slow on my system root and didn't
really seem to achieve anything on either of them).
