Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36844 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932132AbcKPMss (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:48:48 -0500
Received: by mail-it0-f66.google.com with SMTP id n68so6927070itn.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Nov 2016 04:48:48 -0800 (PST)
Subject: Re: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to
 find block group for 0
To: Martin Steigerwald <martin.steigerwald@teamix.de>,
        Roman Mamedov <rm@romanrm.net>
References: <18970348.FUMEOFOSb3@merkaba> <20161116154336.543a326b@natsu>
 <3374757.aMVjisyVFB@merkaba>
Cc: linux-btrfs@vger.kernel.org, Martin <martin@lichtvoll.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f665fdd3-01e2-a947-fdb5-d4f12dfdf6c9@gmail.com>
Date: Wed, 16 Nov 2016 07:48:39 -0500
MIME-Version: 1.0
In-Reply-To: <3374757.aMVjisyVFB@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-16 05:55, Martin Steigerwald wrote:
> Am Mittwoch, 16. November 2016, 15:43:36 CET schrieb Roman Mamedov:
>> On Wed, 16 Nov 2016 11:25:00 +0100
>>
>> Martin Steigerwald <martin.steigerwald@teamix.de> wrote:
>>>     merkaba:~> mount -o degraded,clear_cache /dev/satafp1/backup /mnt/zeit
>>>     mount: Falscher Dateisystemtyp, ungültige Optionen, der
>>>     Superblock von /dev/mapper/satafp1-backup ist beschädigt, fehlende
>>>     Kodierungsseite oder ein anderer Fehler
>>>
>>>           Manchmal liefert das Systemprotokoll wertvolle Informationen –
>>>           versuchen Sie  dmesg | tail  oder ähnlich
>>>
>>>     merkaba:~#32> dmesg | tail -6
>>>     [ 3080.120687] BTRFS info (device dm-13): allowing degraded mounts
>>>     [ 3080.120699] BTRFS info (device dm-13): force clearing of disk cache
>>>     [ 3080.120703] BTRFS info (device dm-13): disk space caching is
>>>     enabled
>>>     [ 3080.120706] BTRFS info (device dm-13): has skinny extents
>>>     [ 3080.150957] BTRFS warning (device dm-13): missing devices (1)
>>>     exceeds the limit (0), writeable mount is not allowed
>>>     [ 3080.195941] BTRFS: open_ctree failed
>>
>> I have to wonder did you read the above message? What you need at this point
>> is simply "-o degraded,ro". But I don't see that tried anywhere down the
>> line.
>>
>> See also (or try): https://patchwork.kernel.org/patch/9419189/
>
> Actually I read that one, but I read more into it than what it was saying:
>
> I read into it that BTRFS would automatically use a read only mount.
>
>
> merkaba:~> mount -o degraded,ro /dev/satafp1/daten /mnt/zeit
>
> actually really works. *Thank you*, Roman.
>
>
> I do think that above kernel messages invite such a kind of interpretation
> tough. I took the "BTRFS: open_ctree failed" message as indicative to some
> structural issue with the filesystem.
Technically, the fact that a device is missing is a structural issue 
with the FS.  Whether or not that falls under what any arbitrary person 
considers a structural issue or not is a different story.

General background though:
open_ctree is one of the core functions in the BTRFS code used during 
mounting the filesystem.  Everything that calls it checks the return 
code and spits out 'BTRFS: open_ctree failed' if it failed.  The problem 
is, just about everything internal (and many external things as well) to 
the BTRFS code that could prevent the FS from mounting happens either in 
open_ctree, or in a function it calls, so all that that line tells us is 
that the mount failed, which is less than useful in most cases.  Given 
both the confusion you've experienced regarding this (which has happened 
to other people too), combined with the amount of effort I've had to put 
in to get the rest of the SysOps people where I work to understand that 
that message just means 'mount failed', I would really love to see that 
just be replaced with 'mount failed' in non-debug builds, preferrably 
with better info about _why_ things failed (the case of a degraded 
filesystem is pretty covered, but most other cases other than 
incompatible feature bits are not).
>
> So mounting work although for some reason scrubbing is aborted (I had this
> issue a long time ago on my laptop as well). After removing /var/lib/btrfs
> scrub status file for the filesystem:
Last I knew, scrub doesn't work on degraded filesystems (in fact, by 
definition, it _can't_ work on a degraded array).  It absolutely won't 
work though without the read-only flag on filesystems which are mounted 
read-only.
>
>     merkaba:~> btrfs scrub start /mnt/zeit
>     scrub started on /mnt/zeit, fsid […] (pid=9054)
>     merkaba:~> btrfs scrub status /mnt/zeit
>     scrub status for […]
>             scrub started at Wed Nov 16 11:52:56 2016 and was aborted after
> 00:00:00
>             total bytes scrubbed: 0.00B with 0 errors
>
> Anyway, I will now just rsync off the files.
>
> Interestingly enough btrfs restore complained about looping over certain
> files… lets see whether the rsync or btrfs send/receive proceeds through.
I'd expect rsync to be more likely to work than send/receive.  In 
general, if you can read the files, rsync will work, whereas 
send/receive needs to read some low-level data from the FS which may not 
be touched when just reading files, so there are cases where rsync will 
work but send/receive won't.
