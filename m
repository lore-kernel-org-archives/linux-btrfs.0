Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33766 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbcC0QIY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 12:08:24 -0400
Received: by mail-lf0-f65.google.com with SMTP id s192so1520090lfs.0
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 09:08:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAafysEua=5bDFa=-_Co4YG+LU_kj3B4e7HnfSrE0jox5cNmhg@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
	<CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
	<CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
	<CAAafysE+5tS=k9GFoKyqwK6dJtR4g3Eqairt1cGatCfCxooXeg@mail.gmail.com>
	<CAJCQCtTURu4OJbTfpKzQGAz4g32yaxToPaE9r8+xWt19AYJUig@mail.gmail.com>
	<CAAafysFa8XZgKvKXQqcnZYR8DLbFe3STQA3Y++Wb71PPdf+iuw@mail.gmail.com>
	<CAJCQCtQwc4FDcTPq2mfN7wfUNp9QWEq+XTJA+FEyY4hWrHvHQQ@mail.gmail.com>
	<CAAafysHw3ws3HVgyfN6YVwFN5pru_kuajKev6sQN6+_uprGiRQ@mail.gmail.com>
	<CAJCQCtQzu2X16L_jp7k-Sy8=+ScCekoHEACajcATX_-vMvDwUA@mail.gmail.com>
	<CAAafysGfah-O+CaX0eHKvzsyR52zCW5c6PExajOz16J8XpLzGQ@mail.gmail.com>
	<CAAafysEua=5bDFa=-_Co4YG+LU_kj3B4e7HnfSrE0jox5cNmhg@mail.gmail.com>
Date: Sun, 27 Mar 2016 18:08:22 +0200
Message-ID: <CAPmG0jZUHasMi3hoz_AwH3-gJj=HJcNnLqZeLPwQV1YRXOByrA@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: Henk Slager <eye1tm@gmail.com>
To: John Marrett <johnf@zioncluster.ca>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 27, 2016 at 4:59 PM, John Marrett <johnf@zioncluster.ca> wrote:
>>> If you do want to use a newer one, I'd build against kernel.org, just
>>> because the developers only use that base. And use 4.4.6 or 4.5.
>>
>> At this point I could remove the overlays and recover the filesystem
>> permanently, however I'm also deeply indebted to the btrfs community
>> and want to give anything I can back. I've built (but not installed ;)
>> ) a straight kernel.org 4.5 w/my missing device check patch applied.
>> Is there any interest or value in attempting to switch to this kernel,
>> add/delete a device and see if I experience the same errors as before
>> I tried replace? What information should I gather if I do this?
>
> I've built and installed a 4.5 straight from kernel.org with my patch.
>
> I encountered the same errors in recovery when I use add/delete
> instead of using replace, here's the sequence of commands:
>
> ubuntu@btrfs-recovery:~$ sudo mount -o degraded,ro /dev/sda /mnt
> ubuntu@btrfs-recovery:~$ sudo mount -o remount,rw /mnt
> # Remove first empty device
> ubuntu@btrfs-recovery:~$ sudo btrfs device delete missing /mnt
> # Add blank drive
> ubuntu@btrfs-recovery:~$ sudo btrfs device add /dev/sde /mnt
> # Remove second missing device with data
> ubuntu@btrfs-recovery:~$ sudo btrfs device delete missing /mnt
>
> And the resulting error:
>
> ubuntu@btrfs-recovery:~$ sudo btrfs device delete missing /mnt
> ERROR: error removing the device 'missing' - Input/output error
>
> Here's what we see in dmesg after deleting the missing device:
>
> [  588.231341] BTRFS info (device sdd): relocating block group
> 10560347308032 flags 17
> [  664.306122] BTRFS warning (device sdd): csum failed ino 257 off
> 695730176 csum 2566472073 expected csum 2706136415
> [  664.306164] BTRFS warning (device sdd): csum failed ino 257 off
> 695734272 csum 2566472073 expected csum 2558511802
> [  664.306182] BTRFS warning (device sdd): csum failed ino 257 off
> 695746560 csum 2566472073 expected csum 3360772439
> [  664.306191] BTRFS warning (device sdd): csum failed ino 257 off
> 695750656 csum 2566472073 expected csum 1205516886
> [  664.344179] BTRFS warning (device sdd): csum failed ino 257 off
> 695730176 csum 2566472073 expected csum 2706136415
> [  664.344213] BTRFS warning (device sdd): csum failed ino 257 off
> 695734272 csum 2566472073 expected csum 2558511802
> [  664.344224] BTRFS warning (device sdd): csum failed ino 257 off
> 695746560 csum 2566472073 expected csum 3360772439
> [  664.344233] BTRFS warning (device sdd): csum failed ino 257 off
> 695750656 csum 2566472073 expected csum 1205516886
> [  664.344684] BTRFS warning (device sdd): csum failed ino 257 off
> 695730176 csum 2566472073 expected csum 2706136415
> [  664.344693] BTRFS warning (device sdd): csum failed ino 257 off
> 695734272 csum 2566472073 expected csum 2558511802
>
> Is there anything of value I can do here to help address this possible
> issue in btrfs itself, or should I remove the overlays, replace the
> device and move on?
>
> Please let me know,

I think it is great that with your local patch you managed to get into
a writable situation.
In theory, with for example already a new spare disk already attached
and standby (hot spare patchset and more etc), a direct replace of the
failing disk, so internally or manually with btrfs-replace would have
prevented the few csum and other small errors. It could be that the
errors have another cause than due to the complete failing harddisk
initially, but that won't be easy to trackdown black and white. Also
the ddrescue action and local patch make tracking back difficult and
it was also based on outdated kernel+tools.

I think it is best that you just repeat the fixing again on the real
disks and just make sure you have an uptodate/latest kernel+tools when
fixing the few damaged files.
With   btrfs inspect-internal inode-resolve 257 <path>
you can see what file(s) are damaged.
