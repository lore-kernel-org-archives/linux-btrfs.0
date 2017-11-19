Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mokrynskyi.com ([46.4.12.50]:48498 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbdKSFNh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 00:13:37 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id 36C6C138F
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 05:13:36 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3iPqS3wTF8Gk for <linux-btrfs@vger.kernel.org>;
        Sun, 19 Nov 2017 05:13:35 +0000 (UTC)
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: Re: Unrecoverable scrub errors
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
 <20171118033335.2ha45mvia5edu6p6@angband.pl>
 <277c8155-8651-f593-0f3f-e36add09d943@mokrynskyi.com>
 <CAJCQCtTAvVKUmMdTaD=S-34anDghHWmQcjn76i+Q3wYc58+gTA@mail.gmail.com>
 <f73a2482-e82d-e658-02aa-a2e2988a0012@mokrynskyi.com>
 <CAJCQCtRKPekR+bEE0xaX02Wwz0E_N1wcUxJdc_D-C9By2qMvWw@mail.gmail.com>
Message-ID: <e9428f4b-8eae-1df9-aa2e-3ac96703338a@mokrynskyi.com>
Date: Sun, 19 Nov 2017 07:13:35 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRKPekR+bEE0xaX02Wwz0E_N1wcUxJdc_D-C9By2qMvWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

19.11.17 06:33, Chris Murphy пише:
> On Sat, Nov 18, 2017 at 8:45 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
>> 19.11.17 05:19, Chris Murphy пише:
>>> On Sat, Nov 18, 2017 at 1:15 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
>>>> I can assure you that drive (it is HDD) is perfectly functional with 0 SMART errors or warnings and doesn't have any problems. dmesg is clean in that regard too, HDD itself can be excluded from potential causes.
>>>>
>>>> There were however some memory-related issues on my machine a few months ago, so there is a chance that data might have being written incorrectly to the drive back then (I didn't run scrub on backup drive for a long time).
>>>>
>>>> How can I identify to which files these metadata belong to replace or just remove them (files)?
>>> You might look through the archives about bad ram and btrfs check
>>> --repair and include Hugo Mills in the search, I'm pretty sure there
>>> is code in repair that can fix certain kinds of memory induced
>>> corruption in metadata. But I have no idea if this is that type or if
>>> repair can make things worse in this case. So I'd say you get
>>> everything off this file system that you want, and then go ahead and
>>> try --repair and see what happens.
>> In this case I'm not sure if data were written incorrectly or checksum or both. So I'd like to first identify the files affected, check them manually and then decide what to do with it. Especially there not many errors yet.
>>
>>> One alternative is to just leave it alone. If you're not hitting these
>>> leaves in day to day operation, they won't hurt anything.
>> It was working for some time, but I have suspicion that occasionally it causes spikes of disk activity because of this errors (which is why I run scrub initially).
>>> Another alternative is to umount, and use btrfs-debug-tree -b  on one
>>> of the leaf/node addresses and see what you get (probably an error),
>>> but it might still also show the node content so we have some idea
>>> what's affected by the error. If it flat out refuses to show the node,
>>> might be a feature request to get a flag that forces display of the
>>> node such as it is...
>> Here is what I've got:
>>
>>> nazar-pc@nazar-pc ~> sudo btrfs-debug-tree -b 470069460992 /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
>>> btrfs-progs v4.13.3
>>> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
>>> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
>>> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
>>> checksum verify failed on 470069460992 found FD171FBB wanted 54C49539
>>> Csum didn't match
>>> ERROR: failed to read 470069460992
>> Looks like I indeed need a --force here.
>>
> Huh, seems overdue. But what do I know?
>
> You can use btrfs-map-logical -l to get a physical address for this
> leaf, and then plug that into dd
>
> # dd if=/dev/ skip=<physicaladress> bs=1 count=16384 2>/dev/null | hexdump -C
>
> Gotcha of course is this is not translated into the more plain
> language output by btrfs-debug-tree. And you're in the weeds with the
> on disk format documentation. But maybe you'll see filenames on the
> right hand side of the hexdump output and maybe that's enough... Or
> maybe it's worth computing a csum on that leaf to check against the
> csum for that leaf which is found in the first field of the leaf. I'd
> expect the csum itself is what's wrong, because if you get memory
> corruption in creating the node, the resulting csum will be *correct*
> for that malformed node and there'd be no csum error, you'd just see
> some other crazy faceplant.

That was eventually useful:

* found some familiar file names (mangled eCryptfs file names from times when I used it for home directory) and decided to search for it in old snapshots of home directory (about 1/3 of snapshots on that partition)
* file name was present in snapshots back to July of 2015, but during search through snapshot from 2016-10-26_18:47:04 I've got I/O error reported by find command at one directory
* tried to open directory in file manager - same error, fails to open
* after removing this lets call it "broken" snapshot started new scrub, hopefully it'll finish fine

If it is not actually related to recent memory issues I'd be positively surprised. Not sure what happened towards the end of October 2016 though, especially that backups were on different physical device back then.

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

