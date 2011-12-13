From: 810d4rk <810d4rk@gmail.com>
Subject: Re: btrfs encryption problems
Date: Tue, 13 Dec 2011 11:58:24 +0000
Message-ID: <CAAVfQjnHkovhOQcWcRGAXON6ywfBAFHuT9vwp8QBf8hVd+wkjw@mail.gmail.com>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
	<20111123110956.GB31800@attic.humilis.net>
	<CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
	<20111124160617.680b676f@zougloub.eu>
	<CAAVfQj=gM7ikTzdFmi=yNpo9guukQwFyKfdu7jD=z-J2PwrZEg@mail.gmail.com>
	<20111124165429.10496040@Bidule>
	<CAAVfQjmmXnyCmXerCyymEQm-DhDxi0YSSo9sVSvkHE1WvJ4wYA@mail.gmail.com>
	<20111130134814.GW24338@shiny>
	<CAAVfQjk+O_3uLb=DShFwV2gVnLeDzQ45ebpMidDGFXZtqXJBbQ@mail.gmail.com>
	<CAG1y0scRTcpHxEnRHgeKgFtYgVYJdgMFydZfXmKEOnRQvUpcQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	=?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>,
	sander@humilis.net, linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0scRTcpHxEnRHgeKgFtYgVYJdgMFydZfXmKEOnRQvUpcQA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

The disk is decrypted, after that I try to mount and it doesn't mount,
this last message appears on the log after trying to mount the btrfs
disk:

> [  660.040263] EXT4-fs (dm-4): VFS: Can't find ext4 filesystem

On 13/12/2011, Fajar A. Nugraha <list@fajar.net> wrote:
> On Thu, Dec 1, 2011 at 5:15 AM, 810d4rk <810d4rk@gmail.com> wrote:
>> I plugged it directly by sata and this is what I get from the 3.1 kernel:
>
>> [  581.921417]  sdb: sdb1
>> [  581.921642] sd 2:0:0:0: [sdb] Attached SCSI disk
>> [  660.040263] EXT4-fs (dm-4): VFS: Can't find ext4 filesystem
>
> ... and then what? Did you try decrypting and mounting it?
>
> --
> Fajar
>


-- 
Thanks
