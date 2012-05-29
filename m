Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41120 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2E2Xha (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 19:37:30 -0400
Received: by qcro28 with SMTP id o28so2275740qcr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:37:29 -0700 (PDT)
Message-ID: <4FC55DB8.6010709@gmail.com>
Date: Tue, 29 May 2012 19:37:28 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
References: <4FC54A5D.8000600@gmail.com> <4FC55043.4050004@gmail.com> <CAE5mzvg_gLxkYhE1h7aunvvYHgsKjpo2xfLqv4A++S=UAOiySw@mail.gmail.com> <4FC55AB7.3000903@gmail.com>
In-Reply-To: <4FC55AB7.3000903@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I forgot to add.
Btrfs-tools was build from:
git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git



On 05/29/2012 07:24 PM, Maxim Mikheev wrote:
> Thank you for your answer.
>
>
> The system kernel was and now:
> Linux s0 3.4.0-030400-generic #201205210521 SMP Mon May 21 09:22:02 
> UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>
> the raid was created by:
> mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
>
> Disk are connected through RocketRaid 2670.
>
> for mounting I used line in fstab:
> UUID=c9776e19-37eb-4f9c-bd6b-04e8dde97682    /tank        btrfs    
> defaults,compress=lzo    0    1
>
> On machine was running several Virtual machines. Only one was actively 
> using disks.
>
> VM has active several threads:
> 1. 2 threads reading big files (50GB each)
> 2. reading from 50 files and writing one big file
> 3. The kernel panic happens when I run another program with 30 threads 
> of reading/writing of small files.
>
> Virtual Machine accessed to underline btrfs through 9-p file system 
> which actively used xattr.
>
> After reboot system was in this stage.
>
> I hope that btrfsck --repair will not make it worse, It is now running.
>
> .................................
> Backups, you everytime need them when you don't have.....
> We was urgently need extra space and planed to buy new disks soon.....
>
>
> On 05/29/2012 07:11 PM, cwillu wrote:
>> I can't help much at the moment, but the following will help sort 
>> things out:
>>
>> Can you provide as much detail as possible about how things were
>> configured at the time of the failure?  Raid levels used, kernel
>> versions at the time of the failure, how the disks are connected,
>> general description of the activity on the disk and the nature of its
>> contents (all large files? rootfs? mail spools?)  What you were
>> thinking at the time you decided that you couldn't afford backups? As
>> much detail as possible on what all you've tried since the failure to
>> recover things?
>>
>> It's likely the data is fine (if currently inaccessible), but
>> obviously things are in a fragile state, and the important thing right
>> now is to not make things worse: a recoverable situation may otherwise
>> turn into an irrecoverable one.
