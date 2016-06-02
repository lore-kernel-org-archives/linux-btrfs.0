Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38770 "EHLO
	mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408AbcFBM4b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 08:56:31 -0400
Received: by mail-it0-f52.google.com with SMTP id i127so50339318ita.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 05:56:31 -0700 (PDT)
Subject: Re: "No space left on device" and balance doesn't work
To: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bcf8033b-bafe-f927-efdb-b898d2b00a24@gmail.com>
Date: Thu, 2 Jun 2016 08:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-01 14:30, MegaBrutal wrote:
> Hi all,
>
> I have a 20 GB file system and df says I have about 2,6 GB free space,
> yet I can't do anything on the file system because I get "No space
> left on device" errors. I read that balance may help to remedy the
> situation, but it actually doesn't.
>
>
> Some data about the FS:
>
>
> root@ReThinkCentre:~# df -h /
> Fájlrendszer                Méret Fogl. Szab. Fo.% Csatol. pont
> /dev/mapper/centrevg-rootlv   20G   18G  2,6G  88% /
>
> root@ReThinkCentre:~# btrfs fi show /
> Label: 'RootFS'  uuid: 3f002b8d-8a1f-41df-ad05-e3c91d7603fb
>         Total devices 1 FS bytes used 15.42GiB
>         devid    1 size 20.00GiB used 20.00GiB path /dev/mapper/centrevg-rootlv
>
> root@ReThinkCentre:~# btrfs fi df /
> Data, single: total=16.69GiB, used=14.14GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=1.62GiB, used=1.28GiB
> GlobalReserve, single: total=352.00MiB, used=0.00B
>
> root@ReThinkCentre:~# btrfs version
> btrfs-progs v4.4
>
>
> This happens when I try to balance:
>
> root@ReThinkCentre:~# btrfs fi balance start -dusage=66 /
> Done, had to relocate 0 out of 33 chunks
> root@ReThinkCentre:~# btrfs fi balance start -dusage=67 /
> ERROR: error during balancing '/': No space left on device
> There may be more info in syslog - try dmesg | tail
>
>
> "dmesg | tail" does not show anything related to this.
>
> It is important to note that the file system currently has 32
> snapshots of / at the moment, and snapshots taking up all the free
> space is a plausible explanation. Maybe deleting some of the oldest
> snapshots or just increasing the file system would help the situation.
> However, I'm still interested, if the file system is full, why does df
> show there is free space, and how could I show the situation without
> having the mentioned options? I actually have an alert set up which
> triggers when the FS usage reaches 90%, so then I know I have to
> delete some old snapshots. It worked so far, I cleaned the snapshots
> at 90%, FS usage fell back, everyone was happy. But now the alert
> didn't even trigger because the FS is at 88% usage, so it shouldn't be
> full yet.
The first thing that needs to be understood is that df has been pretty 
much unchanged since it was introduced in the 70's (IIRC, it was in at 
least SVR4, possibly earlier UNIX versions too).  Back then, it was 
pretty easy to say what percentage of space was used and how much is 
left.  Back then, a filesystem only allocated one set of blocks for a 
file, and it didn't need extra space for updates, and the file took up 
exactly as much space as it's size on disk (usually, it can get kind of 
complicated based on a number of factors).  In addition, traditional UFS 
had a fixed size metadata area for the inodes, which simplified 
computations even more.

In BTRFS though, almost all of these assumptions which the original 
interface made aren't guaranteed.

Now, the biggest difference though is in how BTRFS allocates space. 
BTRFS uses a two tier allocation system.  First, you have high-level 
allocations of what are usually referred to as chunks, and then it 
allocates blocks within those chunks.  The balance operation operates at 
the chunk level, whereas things like defragmentation operate at the 
block level.  For performance reasons, BTRFS usually has separate chunks 
for metadata and data.  Data chunks are usually 1GB, and metadata chunks 
are usually 256MB, although both can vary in size based on the size of 
the filesystem.  Figuring out the exact size gets tricky on a live 
filesystem, but if your filesystem is between 16G and 64G, you're pretty 
much guaranteed to have chunks which are the default size.

Now, because of the segregation of data and metadata, and how chunk 
allocation works, it's possible to end up in a situation where you 
technically have free space, but you can't actually do anything with it. 
  This is because most file operations on BTRFS require at least a few 
blocks of metadata space so that the COW updates can happen.  You 
luckily don't appear to be quite to that point.

For compatibility reasons, we have to report _something_ through df.  We 
can't however report many of the situational things about the state of 
the FS itself (for example, if you have all the possible chunks 
allocated, no space in data chunks, but free space in metadata chunks, 
it's possible to create a lot of very small files, but creating a big 
one will fail).  As a result of this, what we report through df is 
technically absolutely correct (in your case, you _do_ technically have 
2.6G of free space), but is also absolutely useless for any kind of 
management decision.

In your particular situation, what's happened is that you have all the 
space allocated to chunks, but have free space within those chunks. 
Balance never puts data in existing chunks, and you can't allocate any 
new chunks, so you can't run a balance.  However, because of that free 
space in the chunks, you can still use the filesystem itself for 
'regular' filesystem operations.

In this situation, Henk's suggestion of adding another device is one of 
three options for dealing with this.  The other two options (which are 
usually less practical for most people) are to resize the filesystem to 
have more space, or recreate it from scratch.

As far as avoiding this in the future, the best option is to keep an eye 
on the output of fi show, and keep the per-device 'used' value at least 
a few GB below the device size.  I usually go for about 2GB or 0.2% of 
the device size, whichever is bigger.  This will give you enough 
headroom for at least a few chunks to be allocated so that balance can 
proceed.
