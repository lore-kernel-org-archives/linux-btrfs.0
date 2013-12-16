Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:63372 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab3LPQcu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 11:32:50 -0500
Received: by mail-vb0-f48.google.com with SMTP id f13so3304416vbg.35
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 08:32:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387207097.18897.6.camel@ret.masoncoding.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	<CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	<337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	<CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	<840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
	<CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
	<1387207097.18897.6.camel@ret.masoncoding.com>
Date: Mon, 16 Dec 2013 17:32:49 +0100
Message-ID: <CAD_cGvGjkqPXp8guiBR4UsGCQti6rFgRN4Qg+fXLgfE-WkTtEg@mail.gmail.com>
Subject: Re: Blocket for more than 120 seconds
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, I guess the essence have been lost in the meta discussion.

Basically I get blocking for more than 120 seconds during these workloads:
- defragmenting several large fragmentet files in succession (leaving
time for btrfs to finish writing each file). This have *always*
happened in my array, even when it just consisted of 4x4TB drives.
or
- rsyncing *to* the btrfs array from another internal array (rsync -a
<source_on_ext4_mdadm_array> <dest_on_btrfs_raid10_array>)

rsyncing *from* the btrfs array is not a problem, so my issue seems to
be contained to heavy writing.
This is happening even if the server is doing nothing else, no
backups, no torrenting, no copying. The only "external" thing that is
happening is a regular poll from smartd to the drives and regular
filesystem size checks from check_mk (Icinga monitoring).

The FS has a little over 3 TB free (of 29 TB available for RAID10 data
and metadata) and contains mainly largish files like FLAC-files,
photos and large mkv files, ranging from 250 MB to around 70 GB, one
subvolume and one snapshot of that subvolume.
"find /storage/storage-vol0/ -xdev -type f | wc -l" gives a result of
131 820 files. No hard linking is used.

I am currenty removing a drive from the array, reducing the number of
drvies from 8 to 7. The rebalance have not blocked for more than 120
seconds yet, but it is clearly blocking for a quite a few seconds once
in a while as all other software using the drives can't get anything
through and hangs for a period.
I do expect slowdowns during heavy load, but not blocking. The ext4
mdadm RAID6 array in the same server have only been slow during heavy
load, but never blocked noticeably.
Mvh

Hans-Kristian Bakke


On 16 December 2013 16:18, Chris Mason <clm@fb.com> wrote:
> On Sun, 2013-12-15 at 03:35 +0100, Hans-Kristian Bakke wrote:
>> I have done some more testing. I turned off everything using the disk
>> and only did defrag. I have created a script that gives me a list of
>> the files with the most extents. I started from the top to improve the
>> fragmentation of the worst files. The most fragmentet file was a file
>> of about 32GB with over 250 000 extents!
>> It seems that I can defrag a two to three largish (15-30GB) ~100 000
>> extents files just fine, but after a while the system locks up (not a
>> complete hard lock, but everythings hangs and a restart is necessary
>> to get a fully working system again)
>>
>> It seems like defrag operations is triggering the issue. Probably in
>> combination with the large and heavily fragmentet files.
>>
>
> I'm trying to understand how defrag factors into your backup workload?
> Do you have autodefrag on, or are you running a defrag as part of the
> backup when you see these stalls?
>
> If not, we're seeing a different problem.
>
> -chris
>
