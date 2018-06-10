Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scc-mailout-kit-02.scc.kit.edu ([129.13.231.82]:60244 "EHLO
        scc-mailout-kit-02.scc.kit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753451AbeFJNiz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Jun 2018 09:38:55 -0400
From: Simon Kaiser <simon.kaiser@kit.edu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: corrupt leaf; unaligned key offset for csum item
In-Reply-To: <aa02c8c9-7ce7-eb8d-18e8-d810532083d8@gmx.com>
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me> <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com> <CAJCQCtQzd=pKySzt1aJoABHw3kEYxUnJMqCAZhBnmxSNV43=EQ@mail.gmail.com> <aa02c8c9-7ce7-eb8d-18e8-d810532083d8@gmx.com>
Date: Sun, 10 Jun 2018 15:38:49 +0200
Message-ID: <87wov63gnq.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo <quwenruo.btrfs@gmx.com> writes:

> On 2018年06月10日 11:53, Chris Murphy wrote:
>> On Sat, Jun 9, 2018 at 7:56 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>> Indeed, the corrupted bytenr is 0x4bc98004.
>>> Looks pretty like a bit flip in the 3rd lowest bit.
>>>
>>> It can be fixed by manually patching the corrupted leaf to get rid of
>>> the bitflip.
>>> I could provide a special branch of btrfs-progs to fix it easily.
>>>
>>> But before that, it's better to do a scrub to see if there is other
>>> similar problems, so I could fix them all.
>>>

Online scrub `btrfs scrub start -B -r /mnt/` (`mount -o ro,norecovery`)

ERROR: scrubbing /mnt/ failed for device id 1: ret=-1, errno=5 (Input/output error)
scrub canceled for 95b4974b-a798-44b3-99aa-a4eef990aeeb
        scrub started at Sun Jun 10 13:25:37 2018 and was aborted after 00:00:03
        total bytes scrubbed: 1.09GiB with 0 errors

Offline scrub `btrfs check --check-data-csum /dev/sda5`

Checking filesystem on /dev/sda5
UUID: 95b4974b-a798-44b3-99aa-a4eef990aeeb
checking extents
checking free space cache
checking fs roots
root 257 inode 7984709 errors 1000, some csum missing
root 257 inode 8016535 errors 800, odd csum item
root 407 inode 7984709 errors 1000, some csum missing
ERROR: errors found in fs roots
found 83859496960 bytes used, error(s) found
total csum bytes: 79588008
total tree bytes: 1907539968
total fs tree bytes: 1707540480
total extent tree bytes: 93782016
btree space waste bytes: 338263641
file data blocks allocated: 97127669760
 referenced 108545990656
btrfs check --check-data-csum /dev/sda5  10.70s user 1.51s system 82% cpu 14.736 total

>> 
>> Do you think Simon should try -o ro and -o ro,norecovery and see if he
>> can update backups the easy way first?

On copying from this drive, btrfs throws the error I posted initally on
lots of files, but the rest look ok.  I also dd'ed the partition on a
backup drive, so I should be good to go on.

>
> If the bit flip is the only problem, I could fix it manually and nothing
> is lost, the fs can be used as usual.
>
>> And then use the offline scrub
>> to check for additional problems?
>
> I mean online scrub.
>
> I didn't notice extra error, and I don't believe even for a faulty
> memory, bit flip is that easy to happen, so on-line scrub should do the
> work.
>

>> 
>> Simon, the offline scrub is done unmounted with 'btrfs check
>> --check-data-csum <dev>' and it is a read-only check.
>> 
>>

Thank you both for looking into this!

Yours,
Simon
