Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45661 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaAXMzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 07:55:41 -0500
Received: by mail-pa0-f52.google.com with SMTP id bj1so3237258pad.39
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 04:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52E1582F.9080308@friendlyvirus.org>
References: <52E0DF6B.2080200@friendlyvirus.org>
	<52E124E0.4040702@fb.com>
	<52E1582F.9080308@friendlyvirus.org>
Date: Fri, 24 Jan 2014 13:55:40 +0100
Message-ID: <CAFTPBcLw8apHf0rS4U1y-vqMeXUsEgoxnY2L2c95L2H4_fp5RA@mail.gmail.com>
Subject: Re: btrfs send 3.11 vs 3.12
From: Felix Blanke <felixblanke@gmail.com>
To: =?UTF-8?Q?Miguel_Negr=C3=A3o?=
	<miguel.negrao-lists@friendlyvirus.org>
Cc: Josef Bacik <jbacik@fb.com>, "list, btrfs" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please take a look into this thread:

http://www.spinics.net/lists/linux-btrfs/msg30573.html

I had a similiar problem and got the answer + a fix from the list.

Regards,
Felix

On Thu, Jan 23, 2014 at 6:58 PM, Miguel Negrão
<miguel.negrao-lists@friendlyvirus.org> wrote:
> Em 23-01-2014 14:19, Josef Bacik escreveu:
>>
>> On 01/23/2014 04:22 AM, Miguel Negrão wrote:
>>> Hi
>>>
>>> Sending snapshots incrementally started to fail on the 3.11 kernel on my
>>> system after I once booted with 3.12 and did the incremental send of a
>>> snapshot. After when I booted back to 3.11 I can no longer send the
>>> snapshots incrementally based on the last one sent (I could still send
>>> based on the last one sent from 3.11), although booting again to 3.12 I
>>> can send me fine again.
>>>
>>> It this intenteded ?
>> This is definitely not intended, I will look into why this is
>> happening.  Thanks,
>
> Great, thanks.  The error:
>
>> miguel@miguel-MacBookPro:~$ sudo btrfs send -p /mnt/ssd/backups/@-2014-01-22-11\:29/ /mnt/ssd/backups/@-2014-01-23-17\:51/ | sudo btrfs receive /media/miguel/backup/backups/@
>> At subvol /mnt/ssd/backups/@-2014-01-23-17:51/
>> At snapshot @-2014-01-23-17:51
>> ERROR: could not find parent subvolume
>
>> miguel@miguel-MacBookPro:~$ ls -l /media/miguel/backup/backups/@
>> total 0
> ...
>> drwxr-xr-x 1 root root 358 Jan 22 11:31 @-2014-01-22-11:29
>
> Don't know if it's relevant, but I'm already mounting the filesystem
> with subvolid=5 since was an issue too:
>
>> sudo mount -o subvolid=5 -U f2e4e4d3-2d8e-4764-a818-de9176405c4b /mnt/ssd
>
> best,
> Miguel
>
>
>
>
>
>
> --
> Miguel Negrão
> http://www.friendlyvirus.org/miguelnegrao
>
