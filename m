Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:44088 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbeFJVa4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Jun 2018 17:30:56 -0400
Received: by mail-oi0-f42.google.com with SMTP id c128-v6so16222554oig.11
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jun 2018 14:30:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wov63gnq.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
 <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com> <CAJCQCtQzd=pKySzt1aJoABHw3kEYxUnJMqCAZhBnmxSNV43=EQ@mail.gmail.com>
 <aa02c8c9-7ce7-eb8d-18e8-d810532083d8@gmx.com> <87wov63gnq.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 10 Jun 2018 15:30:54 -0600
Message-ID: <CAJCQCtSrxUk0HBBVADKn202LpAhxhxxTek8Dycxv9gd8fJmsUQ@mail.gmail.com>
Subject: Re: corrupt leaf; unaligned key offset for csum item
To: Simon Kaiser <simon.kaiser@kit.edu>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 10, 2018 at 7:38 AM, Simon Kaiser <simon.kaiser@kit.edu> wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>
>> On 2018年06月10日 11:53, Chris Murphy wrote:
>>> On Sat, Jun 9, 2018 at 7:56 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>> Indeed, the corrupted bytenr is 0x4bc98004.
>>>> Looks pretty like a bit flip in the 3rd lowest bit.
>>>>
>>>> It can be fixed by manually patching the corrupted leaf to get rid of
>>>> the bitflip.
>>>> I could provide a special branch of btrfs-progs to fix it easily.
>>>>
>>>> But before that, it's better to do a scrub to see if there is other
>>>> similar problems, so I could fix them all.
>>>>
>
> Online scrub `btrfs scrub start -B -r /mnt/` (`mount -o ro,norecovery`)
>
> ERROR: scrubbing /mnt/ failed for device id 1: ret=-1, errno=5 (Input/output error)
> scrub canceled for 95b4974b-a798-44b3-99aa-a4eef990aeeb
>         scrub started at Sun Jun 10 13:25:37 2018 and was aborted after 00:00:03
>         total bytes scrubbed: 1.09GiB with 0 errors

Is there any kernel message at the time of this i/o error? Either
Btrfs or device error?




-- 
Chris Murphy
