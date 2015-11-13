Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33026 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151AbbKMQMo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 11:12:44 -0500
Received: by lffz63 with SMTP id z63so55260738lff.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 08:12:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564486F3.5020804@gmail.com>
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
	<564486F3.5020804@gmail.com>
Date: Fri, 13 Nov 2015 17:12:43 +0100
Message-ID: <CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
Subject: Re: illegal snapshot, cannot be deleted
From: Vedran Vucic <vedran.vucic@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I succeeded to delete illegal snapshot with command:
btrfs subvolume delete /.snapshots/741/snapshot
When I have done
btrfs balance / -dusage=0 -musage=0
increasing value up to 4o I did not have issues.
But on value 4- for-dusage= and -musage=
I got message that there is no space left on disk.
Do you have any advice how to manage that?

Vedran


On Thu, Nov 12, 2015 at 1:32 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-11-11 17:11, Vedran Vucic wrote:
>>
>> Hello,
>>
>> I use OpenSuse 13.2 on my Toshiba Satellite laptop. I noticed that I run
>> out of disk space, checked documentation and I realized that there were
>> many snapshots.  I used Yast Snapper to delete snapshots.
>> I noticed that one snapshot  with number 748 could not be deleted.
>> I entered terminal and after the command:
>> snapper -c root delete 748
>> I got message Illegal snapshot.
>
> This sounds like some sort of issue with snapper, not BTRFS itself, but see
> below for some suggestions.
>>
>> I woudl like to delete it since it is old one.
>> Please find details about my system as requested on your wiki page.
>> uname -a
>> Linux linux-jjcc.site 3.16.7-29-desktop #1 SMP PREEMPT Fri Oct 23 00:46:04
>> UTC 2015 (6be6a97) i686 i686 i386 GNU/Linux
>>
>> btrfs --version
>> btrfs-progs v4.0+20150429
>>
>> btrfs fi show
>> Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
>>          Total devices 1 FS bytes used 10.98GiB
>>          devid    1 size 18.71GiB used 18.71GiB path /dev/sda6
>>
>> btrfs fi df /
>> Data, single: total=15.19GiB, used=10.37GiB
>> System, DUP: total=8.00MiB, used=16.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, DUP: total=1.75GiB, used=622.53MiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=208.00MiB, used=0.00B
>> Please find attached dmesg.log as requested.
>>
>> Please advise what have to do in order to delete snapshot that is reported
>> to be illegal.
>
> Have you tried running 'btrfs subvolume delete' on the snapshot?  You'll
> have to find the full path to it first of course, but that shouldn't be too
> hard.  Based on the lack of BTRFS error messages in the kernel log you
> posted, I'm pretty certain that this isn't an issue with the filesystem
> itself (although the filesystem doesn't look particularly healthy, see
> further below), so manually deleting the snapshot using the regular BTRFS
> commands should work just fine.  That said, you may also want to look into
> changing the config for snapper, as it has a ridiculously aggressive
> retention policy for snapshots by default, which tends to lead to excessive
> space usage on filesystems smaller than about 250GB.
>
> You may also want to look at running a balance on the filesystem, the
> numbers from btrfs fi show and btrfs fi df look somewhat worrying, you've
> got all the space on the disk allocated as chunks by BTRFS, but have a
> significant amount of empty space in those chunks.  Given that fact, ENOSPC
> issues are a very real possibility, and you'll probably have to run a series
> of partial balances to fix this (and it's important to do it before it
> becomes a visible issue also, because once you start getting ENOSPC errors,
> it is a lot harder to fix).  Try running a balance with '-dusage=0
> -musage=0', then re-run repeatedly increasing the number for both arguments
> by 5 each time until you get to 50.  If a run complains about 'ENOSPC errors
> during balance', re-run it with the same number for -dusage and -musage.  If
> you end up re-running with the same value 3 times and keep getting the
> errors, then you're probably beyond the point of this being fixable, and
> should just recreate the filesystem (you do have backups, right?).
> Otherwise, after finishing the run with '-dusage=50 -musage=50'
> successfully, run a full balance without the dusage and musage options.
>
>
>
