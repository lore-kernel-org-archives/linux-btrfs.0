Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scc-mailout-kit-01.scc.kit.edu ([129.13.231.81]:41936 "EHLO
        scc-mailout-kit-01.scc.kit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753486AbeFJWcX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Jun 2018 18:32:23 -0400
From: Simon Kaiser <simon.kaiser@kit.edu>
To: Chris Murphy <lists@colorremedies.com>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: corrupt leaf; unaligned key offset for csum item
In-Reply-To: <CAJCQCtSrxUk0HBBVADKn202LpAhxhxxTek8Dycxv9gd8fJmsUQ@mail.gmail.com>
References: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me> <31a293a5-6cad-cd42-b70b-bb23c02233bf@gmx.com> <CAJCQCtQzd=pKySzt1aJoABHw3kEYxUnJMqCAZhBnmxSNV43=EQ@mail.gmail.com> <aa02c8c9-7ce7-eb8d-18e8-d810532083d8@gmx.com> <87wov63gnq.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me> <CAJCQCtSrxUk0HBBVADKn202LpAhxhxxTek8Dycxv9gd8fJmsUQ@mail.gmail.com>
Date: Mon, 11 Jun 2018 00:32:18 +0200
Message-ID: <87y3fm9sst.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> writes:

>> Online scrub `btrfs scrub start -B -r /mnt/` (`mount -o ro,norecovery`)
>>
>> ERROR: scrubbing /mnt/ failed for device id 1: ret=-1, errno=5 (Input/output error)
>> scrub canceled for 95b4974b-a798-44b3-99aa-a4eef990aeeb
>>         scrub started at Sun Jun 10 13:25:37 2018 and was aborted after 00:00:03
>>         total bytes scrubbed: 1.09GiB with 0 errors
>
> Is there any kernel message at the time of this i/o error? Either
> Btrfs or device error?

Around the time of the error, dmesg shows only the btrfs error I
initially posted:

[   73.453640] BTRFS critical (device sda5): corrupt leaf: root=1 block=73263579136 slot=105, unaligned key offset for csum item, have 1271496708 should be aligned to 4096
[   73.791479] BTRFS critical (device sda5): corrupt leaf: root=1 block=73263579136 slot=105, unaligned key offset for csum item, have 1271496708 should be aligned to 4096

Yours,
Simon
