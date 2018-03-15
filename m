Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:32863 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbeCOV0V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 17:26:21 -0400
Received: by mail-ot0-f182.google.com with SMTP id y11-v6so8394461otg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 14:26:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180314135613.4ef005f0b93cb2888abd9750@reasonset.net>
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
 <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com> <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>
 <c938a753-deb6-39bb-0f17-701ec1e0226b@gmx.com> <20180314042507.f20bbf949ce07f88ca01cb38@reasonset.net>
 <CAJCQCtRaUUSWOWGQzJqZVddV9639O0B8eiZzNKTB0DPYowLWoA@mail.gmail.com> <20180314135613.4ef005f0b93cb2888abd9750@reasonset.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Mar 2018 15:26:20 -0600
Message-ID: <CAJCQCtQ4Kv_BePCwYJiwRFFQ1cpip1SNDH5Da8WtCOXNdNg2yQ@mail.gmail.com>
Subject: Re: Btrfs broken in massive transfar
To: MASAKI haruka <yek@reasonset.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 10:56 PM, MASAKI haruka <yek@reasonset.net> wrote:
>> On Tue, Mar 13, 2018 at 1:25 PM, MASAKI haruka <yek@reasonset.net> wrote:
>> > journal(Kernel log), 7th try (to be readonly):
>> >
>> > ---
>> >  3月 12 16:25:51 lily kernel: BTRFS info (device dm-6): creating UUID tree
>> >  3月 12 16:25:53 lily iscsid[1406]: Connection-1:0 to [target: iqn.1994-11.com.netgear:eggplant-01:edc9adcf:btr1group, portal: 192.168.1.166,3260] through [iface: default] is shutdown.
>> >  3月 12 16:25:53 lily iscsid[1406]: IPC qtask write failed: Broken pipe
>> >  3月 12 16:26:18 lily kernel:  connection1:0: detected conn error (1020)
>> >  3月 12 16:26:19 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
>> >  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
>> >  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 Sense Key : 0x2 [current] [descriptor]
>> >  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 ASC=0x8 ASCQ=0x0
>> >  3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 CDB: opcode=0x8a 8a 00 00 00 00 00 00 42 5c 00 00 00 34 00 00 00
>> >  3月 12 16:26:21 lily kernel: print_req_error: I/O error, dev sdg, sector 4348928
>>
>>
>> Looks like network problems. Is one of these Btrfs volumes on an iSCSI
>> device? Because there's a bunch of iSCSI errors followed by an I/O
>> error with sector LBA reported, and then you get a bunch of Btrfs
>> write errors.
>>
>> What's the relationship between /dev/sdg and device (dm-6)
>> /dev/mapper/hymaster_1 ?
>>
>
>
> /dev/mapper/hymaster_1 is dm-crypt plain device.
> Its real device is /dev/sdg it is an iSCSI disk
> connected to NAS over GbE link local.
>
> If this probrem from network, it's looked difficult to solve
> because I tried with two different computers without any other network device...

There's a lot of complexity here. It might be drives on the NAS, it
might networking hardware on the NAS, it could be networking hardware
like switch or cables. It all has to be narrowed down. You'll need
logs for the NAS and try to go from there.

Maybe http://vger.kernel.org/vger-lists.html#linux-scsi is a place to
start to see if these are drive or iSCSI specific problems, or network
problems and then just process of elimination.

But based on available information I don't think this is Btrfs. It's
complaining about a preexisting problem.


-- 
Chris Murphy
