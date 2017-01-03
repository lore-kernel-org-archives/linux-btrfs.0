Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38906 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759515AbdACQBv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 11:01:51 -0500
Received: by mail-it0-f51.google.com with SMTP id x2so300198099itf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jan 2017 08:01:12 -0800 (PST)
Subject: Re: [PATCH] recursive defrag cleanup
To: "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20161206043938.3249-1-anand.jain@oracle.com>
 <20161212171927.GY12522@twin.jikos.cz>
 <9799c1aa-e365-f05d-2b96-017edc67ec90@oracle.com>
 <CANznX5FsY==9svvhmRtAG=9_GE5PHYU34B3Hboq-A36GvTf+pg@mail.gmail.com>
 <9fdde3f9-e2ed-b3d3-a8ec-da6ae27dfe95@oracle.com>
 <CANznX5FPg60U252u-1VDJdb6x7j562bMMSCoRJXF4zTrsayy2Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1e291178-2b84-f4e1-25c8-e4cbd37718ae@gmail.com>
Date: Tue, 3 Jan 2017 11:01:07 -0500
MIME-Version: 1.0
In-Reply-To: <CANznX5FPg60U252u-1VDJdb6x7j562bMMSCoRJXF4zTrsayy2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-03 09:21, Janos Toth F. wrote:
> So, in order to defrag "everything" in the filesystem (which is
> possible to / potentially needs defrag) I need to run:
> 1: a recursive defrag starting from the root subvolume (to pick up all
> the files in all the possible subvolumes and directories)
> 2: a non-recursive defrag on the root subvolume + (optionally)
> additional non-recursive defrag(s) on all the other subvolume(s) (if
> any) [but not on all directories like some old scripts did]
>
> In my opinion, the recursive defrag should pick up and operate on all
> the subvolumes, including the one specified in the command line (if
> it's a subvolume) and all subvolumes "below" it (not on files only).
I agree on this point.  I actually hadn't known that it didn't recurse 
into sub-volumes, and that's a pretty significant caveat that should be 
documented (and ideally fixed, defrag doesn't need to worry about 
cross-subvolume stuff because it breaks reflinks anyway).
>
> Does the -t parameter have any meaning/effect on non-recursive (tree)
> defrag? I usually go with 32M because t>=128Mb tends to be unduly slow
> (it takes a lot of time, even if I try to run it repeatedly on the
> same static file several times in a row whereas t<=32M finishes rather
> quickly in this case -> could this be a bug or design flaw?).
For single directories, -t almost certainly has near zero effect since 
directories are entirely in metadata.  For single files, it should only 
have an effect if it's smaller than the size of the file (it probably is 
for your usage if you've got hour long video files).  As far as the 
behavior above 128MB, stuff like that is expected to a certain extent 
when you have highly fragmented free space (the FS has to hunt harder to 
find a large enough free area to place the extent).

FWIW, unless you have insanely slow storage, 32MB is a reasonable target 
fragment size.  Fragmentation is mostly an issue with sequential reads, 
and usually by the time you're through processing that 32MB of data, 
your storage device will have the next 32MB ready.  The optimal value of 
course depends on many things, but 32-64MB is reasonable for most users 
who aren't streaming multiple files simultaneously off of a slow hard drive.
>
> I have a Btrfs filesystem (among others) on a single HDD with
> single,single,single block profiles which is effectively write-only.
> Nine concurrent ffmpeg processes write files from real-time video
> streams 24/7 (there is no pre-allocation, the files just grow and grow
> for an hour until a new one starts). A daily cronjob deletes the old
> files every night and starts a recursive defrag on the root subvolume
> (there are no other subvolumes, only the default id=5). I appended a
> non-recursive defrag to this maintenance script now but I doubt it
> does anything meaningful in this case (it finishes very fast, so I
> don't think it does too much work). This is the filesystem which
> "degrades" in speed for me very fast and needs metadata re-balance
> from time to time (I usually do it before every kernel upgrades and
> thus reboots in order to avoid a possible localmount rc-script
> timeouts).
>
> I know I should probably use a much more simple filesystem (might even
> vfat, or ext4 - possibly with the journal disabled) for this kind of
> storage but I was curious how Btrfs can handle the job (with CoW
> enabled, no less). All in all, everything is fine except the
> degradation of metadata performance. Since it's mostly write-only, I
> could even skip the file defrags (I originally scheduled it in a hope
> it will overcome the metadata slowdown problems and it's also useful
> [even if not necessary] to have the files defragmented in case I
> occasionally want to use them). I am not sure but I guess defraging
> the files helps to reduce the overall metadata size and thus makes the
> balance step faster (quick balancing) and more efficient (better
> post-balance performance).
Really use case specific question, but have you tried putting each set 
of files (one for each stream) in it's own sub-volume?  Your metadata 
performance is probably degrading from the sheer number of extents 
involved (assuming H.264 encoding and full HD video with DVD quality 
audio, you're probably looking at at least 1000 extents for each file, 
probably more), and splitting into a subvolume per-stream should 
segregate the metadata for each set of files, which should in turn help 
avoid stuff like lock contention (and may actually make both balance and 
defrag run faster).
>
> I can't remember the exact script but it basically fed every single
> directories (not just subvolumes) to the defrag tool using 'find' and
> it was meant to complement a separate recursive defrag step. It was
> supposed to defrag the metadata (the metadata of every single
> directory below the specified location, one by one, so it was very
> quick on my video-archive but very slow on my system root and didn't
> really seem to achieve anything on either of them).
In general, unless you're talking about a directory with tens of 
thousands of entries (which you should be avoiding for other reasons, 
even on other filesystems), defragmenting a directory itself will 
usually have near zero impact on performance on modern storage hardware. 
  In most cases, the whole directory fits entirely in the cache on the 
storage device and gets pre-loaded by read-ahead done by the device 
firmware, so the only optimization is in the lookup itself, which is 
already really efficient because of how BTRFS stores everything in 
B-trees.  You also have to factor in that directories tend to have more 
sticking power than file blocks in the VFS cache, since they're 
(usually) used more frequently, so once you've read the directory the 
first time, it's almost certainly going to be completely in cache.

To put it in perspective, a directory with about 20-25 entries and all 
file/directory names less than 15 characters (roughly typical root 
directory, not counting the . and .. pseudo-entries) easily fits 
entirely in one metadata block on BTRFS with a 16k block size (the 
current default), with lots of room to spare.  My home directory on my 
laptop, which has a total of 129 entries with no names longer than 50 
bytes (and an average filename length of about 30 bytes), fits entirely 
in about 4 16k metadata blocks on BTRFS (assuming I did the math right 
for this one, I may not have).

If the directory is one block or smaller, defrag will do absolutely 
nothing to it (it's already got only one fragment).  If it's more than 
one block, defrag will try to put those blocks together in order, but 
the difference between 4 16k reads and 1 64k read on most modern storage 
devices is near zero, so it often will have near zero impact on that 
aspect of performance unless things are really bad (for example, if I 
had a traditional hard drive and each of those four metadata blocks were 
exactly equally spaced across the whole partition, I might see some 
difference in performance), but even then you're talking small enough 
improvements that you won't notice unless you're constantly listing the 
directory and trashing the page cache at the same time.
