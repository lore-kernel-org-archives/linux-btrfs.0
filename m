Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:32954 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbcKCLv7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Nov 2016 07:51:59 -0400
Received: by mail-yw0-f180.google.com with SMTP id r204so40644185ywb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Nov 2016 04:51:59 -0700 (PDT)
Subject: Re: btrfs scrub with unexpected results
To: Tom Arild Naess <tanaess@gmail.com>, linux-btrfs@vger.kernel.org
References: <84df8b17-65ac-0f40-cf19-471b3664b0b3@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f8ba65d7-5854-e853-221c-4b7f4991b21a@gmail.com>
Date: Thu, 3 Nov 2016 07:51:46 -0400
MIME-Version: 1.0
In-Reply-To: <84df8b17-65ac-0f40-cf19-471b3664b0b3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-02 17:55, Tom Arild Naess wrote:
> Hello,
>
> I have been running btrfs on a file server and backup server for a
> couple of years now, both set up as RAID 10. The file server has been
> running along without any problems since day one. My problems has been
> with the backup server.
>
> A little background about the backup server before I dive into the
> problems. The server was a new build that was set to replace an aging
> machine, and my intention was to start using btrfs send/receive instead
> of hard links for the backups. Since I had 8x the space on the new
> server, I just rsynced the whole lot of old backups to the new server. I
> then made some scripts that created snapshots from the old file
> hierarchy. As I started rewriting my backup scripts (on file server and
> backup server) to use send/receive, I also tested scrubbing to see that
> everything was OK. After doing this a few times, scrub found
> unrecoverable files. This, I thought, should not be possible on new
> disks. I tried to get some help on this list, but no answers were found,
> and since I was unable to find what triggered this, I just stopped using
> send/receive, and let my old backup regime live on on this new backup
> server as well. I don't remember how I fixed the errors, but I guess I
> just replaced the offending files with fresh ones, and scrub ran without
> any more problems. I decided to let things just run like this, and set
> up scrubbing on a monthly schedule.
>
> Last night I got the unpleasant mail from cron telling me that scrub had
> failed (for the first time in over a year). Since I was running on an
> older kernel (4.2.x), I decided to upgrade, and went for the latest of
> the longterm branches, namely 4.4.30. After rebooting I did (for
> whatever reason) check one of the offending files, and I could read the
> file just fine! I checked the rest of the bunch, and all files read
> fine, and had the same md5 sum as the originals! All these files were
> located in those old snapshots. I thought that maybe this was because of
> a bug resolved since my last kernel. Then I ran a new scrub, and this
> one also reported unrecoverable errors. This time on two other files but
> also in some of the old snapshots. I tried reading the files, and got
> the expected I/O errors. One reboot later, these files reads just fine
> again!
So, based on what your saying, this sounds like you have hardware 
problems.  The fact that a reboot is fixing I/O errors caused by 
checksum mismatches tells me that either (in relative order of likelihood):
1. You have some bad RAM (probably not much given the small number of 
errors).
2. You have some bad hardware in the storage path other than the 
physical media in your storage devices.  Any of the storage controller, 
the cabling/back-plane, or the on-disk cache having issues can cause 
things like this to happen.
3. Some other component is having issues.  A PSU that's not providing 
clean power could cause this also, but is not likely unless you've got a 
really cheap PSU.
4. You've found an odd corner case in BTRFS that nobody's reported 
before (this is pretty much certain if you rule out the hardware).

Based on this, what I would suggest doing (in order):
1. Run self-tests on the storage devices using smartctl (and see if they 
think they're healthy or not).  I doubt that this will show anything, 
but it's quick and easy to test and doesn't require taking the system 
off-line, so it's one of the first things to check.
2. Check your cabling.  This is really easy to verify, just disconnect 
and reconnect everything and see if you still have problems.  If you do 
still have problems, try switching out one data (SATA/SAS/whatever you 
use) cable at a time and see if you still have problems (it takes longer 
than using a cable tester, but finding a working cable tester for 
internal computer cables is hard).
3. Check your RAM.  Memtest86 and Memtest86+ are the best options for 
general testing, but I doubt that those will turn up anything.  If you 
have spare RAM, I'd actually suggest just swapping out one DIMM at a 
time and seeing if you still get the behavior your seeing.
4. Check your PSU.  I list this before the storage controller and disks 
because it's pretty easy to test (you just need a PSU tester, which are 
about 15 USD on Amazon, or a good multi-meter, some wire, and some basic 
knowledge of the wiring), but after the RAM because it's significantly 
less likely to be the problem than your RAM unless you've got a really 
cheap PSU.
5. Check your storage controller.  This is _hard_ to do unless you have 
a spare known working storage controller.
6. If you have any extra expansion cards your not using (NIC's, HBA's, 
etc), try pulling them out.  This sounds odd, but I've seen cases where 
the driver for something I wasn't using at all was causing problems 
elsewhere.

Now, assuming none of that turns anything up, then you probably have 
found a bug in BTRFS, but I have no idea in this case how we would go 
about debugging it as it seems to be some kind of in-memory data 
corruption (maybe a buffer overflow?).

>
> Some system info:
>
> $ uname -a
> Linux backup 4.4.30-1-lts #1 SMP Tue Nov 1 22:09:20 CET 2016 x86_64
> GNU/Linux
>
> $ btrfs --version
> btrfs-progs v4.8.2
>
> $ btrfs fi show /backup
> Label: none  uuid: 8825ce78-d620-48f5-9f03-8c4568d3719d
>     Total devices 4 FS bytes used 2.81TiB
>     devid    1 size 2.73TiB used 1.41TiB path /dev/sdb
>     devid    2 size 2.73TiB used 1.41TiB path /dev/sda
>     devid    3 size 2.73TiB used 1.41TiB path /dev/sdd
>     devid    4 size 2.73TiB used 1.41TiB path /dev/sdc

