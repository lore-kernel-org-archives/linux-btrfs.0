Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mokrynskyi.com ([46.4.12.50]:56398 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750888AbdKSLRi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 06:17:38 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id 85BA91379
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 11:17:37 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bmGe3peIz3na for <linux-btrfs@vger.kernel.org>;
        Sun, 19 Nov 2017 11:17:37 +0000 (UTC)
Subject: Re: Unrecoverable scrub errors
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0d0062da-6310-7662-a7ec-edc6591b4542@mokrynskyi.com>
 <CAJCQCtSBxDP7ZyCnQuZZLQXXURrKLT+1Ja61pD_uR0oGH0piDA@mail.gmail.com>
 <20171118033335.2ha45mvia5edu6p6@angband.pl>
 <277c8155-8651-f593-0f3f-e36add09d943@mokrynskyi.com>
 <CAJCQCtTAvVKUmMdTaD=S-34anDghHWmQcjn76i+Q3wYc58+gTA@mail.gmail.com>
 <f73a2482-e82d-e658-02aa-a2e2988a0012@mokrynskyi.com>
 <CAJCQCtRKPekR+bEE0xaX02Wwz0E_N1wcUxJdc_D-C9By2qMvWw@mail.gmail.com>
 <e9428f4b-8eae-1df9-aa2e-3ac96703338a@mokrynskyi.com>
 <CAJCQCtSGXWqTPUfHB467P7rB6yg0oZPOuBCCNU0YE4yzrkejyg@mail.gmail.com>
 <8cdd4e42-8a5d-052a-b894-5cb4450a079f@mokrynskyi.com>
Message-ID: <6db3931f-55d2-ffdd-9fcb-5572b842d824@mokrynskyi.com>
Date: Sun, 19 Nov 2017 13:17:36 +0200
MIME-Version: 1.0
In-Reply-To: <8cdd4e42-8a5d-052a-b894-5cb4450a079f@mokrynskyi.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like it is not going to resolve nicely.

After removing that problematic snapshot filesystem quickly becomes readonly like so:

> [23552.839055] BTRFS error (device dm-2): cleaner transaction attach returned -30
> [23577.374390] BTRFS info (device dm-2): use lzo compression
> [23577.374391] BTRFS info (device dm-2): disk space caching is enabled
> [23577.374392] BTRFS info (device dm-2): has skinny extents
> [23577.506214] BTRFS info (device dm-2): bdev /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1 errs: wr 0, rd 0, flush 0, corrupt 24, gen 0
> [23795.026390] BTRFS error (device dm-2): bad tree block start 0 470069510144
> [23795.148193] BTRFS error (device dm-2): bad tree block start 56 470069542912
> [23795.148424] BTRFS warning (device dm-2): dm-2 checksum verify failed on 470069460992 wanted 54C49539 found FD171FBB level 0
> [23795.148526] BTRFS error (device dm-2): bad tree block start 0 470069493760
> [23795.150461] BTRFS error (device dm-2): bad tree block start 1459617832 470069477376
> [23795.639781] BTRFS error (device dm-2): bad tree block start 0 470069510144
> [23795.655487] BTRFS error (device dm-2): bad tree block start 0 470069510144
> [23795.655496] BTRFS: error (device dm-2) in btrfs_drop_snapshot:9244: errno=-5 IO failure
> [23795.655498] BTRFS info (device dm-2): forced readonly
Check and repaid doesn't help either:

> nazar-pc@nazar-pc ~> sudo btrfs check -p /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> Checking filesystem on /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> UUID: 82cfcb0f-0b80-4764-bed6-f529f2030ac5
> Extent back ref already exists for 797694840832 parent 330760175616 root 0 owner 0 offset 0 num_refs 1
> parent transid verify failed on 470072098816 wanted 1431 found 307965
> parent transid verify failed on 470072098816 wanted 1431 found 307965
> parent transid verify failed on 470072098816 wanted 1431 found 307965
> parent transid verify failed on 470072098816 wanted 1431 found 307965
> Ignoring transid failure
> leaf parent key incorrect 470072098816
> bad block 470072098816
>
> ERROR: errors found in extent allocation tree or chunk allocation
> There is no free space entry for 797694844928-797694808064
> There is no free space entry for 797694844928-797819535360
> cache appears valid but isn't 796745793536
> There is no free space entry for 814739984384-814739988480
> There is no free space entry for 814739984384-814999404544
> cache appears valid but isn't 813925662720
> block group 894456299520 has wrong amount of free space
> failed to load free space cache for block group 894456299520
> block group 922910457856 has wrong amount of free space
> failed to load free space cache for block group 922910457856
>
> ERROR: errors found in free space cache
> found 963515335717 bytes used, error(s) found
> total csum bytes: 921699896
> total tree bytes: 20361920512
> total fs tree bytes: 17621073920
> total extent tree bytes: 1629323264
> btree space waste bytes: 3812167723
> file data blocks allocated: 21167059447808
>  referenced 2283091746816
>
> nazar-pc@nazar-pc ~> sudo btrfs check --repair -p /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> enabling repair mode
> Checking filesystem on /dev/mapper/luks-bd5dd3e7-ad80-405f-8dfd-752f2b870f93-part1
> UUID: 82cfcb0f-0b80-4764-bed6-f529f2030ac5
> Extent back ref already exists for 797694840832 parent 330760175616 root 0 owner 0 offset 0 num_refs 1
> parent transid verify failed on 470072098816 wanted 1431 found 307965
> parent transid verify failed on 470072098816 wanted 1431 found 307965
> parent transid verify failed on 470072098816 wanted 1431 found 307965
> parent transid verify failed on 470072098816 wanted 1431 found 307965
> Ignoring transid failure
> leaf parent key incorrect 470072098816
> bad block 470072098816
>
> ERROR: errors found in extent allocation tree or chunk allocation
> Fixed 0 roots.
> There is no free space entry for 797694844928-797694808064
> There is no free space entry for 797694844928-797819535360
> cache appears valid but isn't 796745793536
> There is no free space entry for 814739984384-814739988480
> There is no free space entry for 814739984384-814999404544
> cache appears valid but isn't 813925662720
> block group 894456299520 has wrong amount of free space
> failed to load free space cache for block group 894456299520
> block group 922910457856 has wrong amount of free space
> failed to load free space cache for block group 922910457856
>
> ERROR: errors found in free space cache
> found 963515335717 bytes used, error(s) found
> total csum bytes: 921699896
> total tree bytes: 20361920512
> total fs tree bytes: 17621073920
> total extent tree bytes: 1629323264
> btree space waste bytes: 3812167723
> file data blocks allocated: 21167059447808
>  referenced 2283091746816
Anything else I can try before starting from scratch?

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

19.11.17 07:30, Nazar Mokrynskyi пише:
> 19.11.17 07:23, Chris Murphy пише:
>> On Sat, Nov 18, 2017 at 10:13 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
>>
>>> That was eventually useful:
>>>
>>> * found some familiar file names (mangled eCryptfs file names from times when I used it for home directory) and decided to search for it in old snapshots of home directory (about 1/3 of snapshots on that partition)
>>> * file name was present in snapshots back to July of 2015, but during search through snapshot from 2016-10-26_18:47:04 I've got I/O error reported by find command at one directory
>>> * tried to open directory in file manager - same error, fails to open
>>> * after removing this lets call it "broken" snapshot started new scrub, hopefully it'll finish fine
>>>
>>> If it is not actually related to recent memory issues I'd be positively surprised. Not sure what happened towards the end of October 2016 though, especially that backups were on different physical device back then.
>> Wrong csum computation during the transfer? Did you use btrfs send receive?
> Yes, I've used send/receive to copy snapshots from primary SSD to backup HDD.
>
> Not sure when wrong csum computation happened, since SSD contains only most recent snapshots and only HDD contains older snapshots. Even if error happened on SSD, those older snapshots are gone a long time ago and there is no way to check this.
>
> Sincerely, Nazar Mokrynskyi
> github.com/nazar-pc
>
