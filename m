Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33537 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbbGATF4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 15:05:56 -0400
Received: by obpn3 with SMTP id n3so34677745obp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2015 12:05:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
 <CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
 <CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com> <CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Wed, 1 Jul 2015 14:05:36 -0500
Message-ID: <CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I should have thought to check this to add earlier.  I'm seeing errors
for /dev/sdg in dmesg (not surprised, I wanted this drive out of the
pool to begin with because it's sick).

[  142.612988] BTRFS: open_ctree failed
[11836.105577] sd 0:0:6:0: [sdg] FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[11836.105585] sd 0:0:6:0: [sdg] Sense Key : Medium Error [current]
[11836.105589] sd 0:0:6:0: [sdg] Add. Sense: Unrecovered read error
[11836.105592] sd 0:0:6:0: [sdg] CDB: Read(10) 28 00 5a 5b f1 b8 00 01 00 00
[11836.105596] blk_update_request: critical medium error, dev sdg,
sector 1515975096
[11839.044815] mpt2sas0: log_info(0x31080000): originator(PL),
code(0x08), sub_code(0x0000)
[11839.044843] sd 0:0:6:0: [sdg] FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[11839.044848] sd 0:0:6:0: [sdg] Sense Key : Medium Error [current]
[11839.044857] sd 0:0:6:0: [sdg] Add. Sense: Unrecovered read error
[11839.044862] sd 0:0:6:0: [sdg] CDB: Read(10) 28 00 5a 5b f2 b8 00 01 00 00
[11839.044865] blk_update_request: critical medium error, dev sdg,
sector 1515975352
[11842.009545] sd 0:0:6:0: [sdg] FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[11842.009554] sd 0:0:6:0: [sdg] Sense Key : Medium Error [current]
[11842.009558] sd 0:0:6:0: [sdg] Add. Sense: Unrecovered read error
[11842.009562] sd 0:0:6:0: [sdg] CDB: Read(10) 28 00 5a 5b f2 80 00 00 08 00
[11842.009565] blk_update_request: critical medium error, dev sdg,
sector 1515975296
[11842.009934] Buffer I/O error on dev sdg, logical block 189496912,
async page read

On Wed, Jul 1, 2015 at 1:58 PM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:
> Small update on this, with no idea if this is useful information or not.
>
> At some point within the last hour iostat shows that /dev/sdg is no
> longer under heavy reads.
>
> The other 9 drives however are still reading as fast as they are able.
> There is no new output on the `btrfs rescue chunk-recover` screen so I
> expect it's still running.
>
> There are 4 other drives with the same total capacity as sdg so I
> would have expected then to normally all complete at about the same
> time.
>
> Regards,
> Donald
>
> On Wed, Jul 1, 2015 at 11:09 AM, Donald Pearson
> <donaldwhpearson@gmail.com> wrote:
>> Thanks Chris,
>>
>> To my shame it turns out darkling didn't drop off IRC after all; I'm
>> new to all this and learning quickly that I need to sit on my hands.
>> I admit despite darkling's suggestion that my usertools are probably
>> fine I pulled down a newer kernel from elrepo so currently I'm running
>> 4.1.1-1.el7.elrepo.x86_64
>>
>> I started with 4.0.2-1.el7.elrepo.x86_64
>>
>> I also do have btrfs-progs 4.1 that I got from git.
>>
>> Here is the 4.0 output
>> [root@san01 btrfs-progs]# btrfs check /dev/sdc
>> checksum verify failed on 21364736 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 21364736 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 21364736 found EC809498 wanted 0863292E
>> checksum verify failed on 21364736 found 925303CE wanted 09150E74
>> checksum verify failed on 21364736 found 925303CE wanted 09150E74
>> bytenr mismatch, want=21364736, have=1065943040
>> Couldn't read chunk tree
>> Couldn't open file system
>>
>> Here is the 4.1 output
>> [root@san01 btrfs-progs]# ./btrfs check /dev/sdc
>> checksum verify failed on 21364736 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 21364736 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 21364736 found EC809498 wanted 0863292E
>> checksum verify failed on 21364736 found 925303CE wanted 09150E74
>> checksum verify failed on 21364736 found 925303CE wanted 09150E74
>> bytenr mismatch, want=21364736, have=1065943040
>> Couldn't read chunk tree
>> Couldn't open file system
>>
>> Finally, before I learned of this mailing list I started a run of
>> btrfs rescue chunk-recover
>> [root@san01 btrfs-progs]# ./btrfs rescue chunk-recover -v /dev/sdc
>>
>> I can see now through iostat that all 10 drives are reading as fast as
>> they can and my understanding is this will take a long time, but I've
>> since learned (not only that darkling was still alive on IRC) that
>> this probably won't solve my problem.
>>
>> Regards,
>> Donald (seijirou)
>>
>> On Wed, Jul 1, 2015 at 10:50 AM, Chris Murphy <lists@colorremedies.com> wrote:
>>> btrfs-progs version is 4.0, what is the kernel versions you've tried
>>> to mount with?
>>>
>>> I suggest running btrfs check (without --repair) and including the
>>> full output. There are a lot of changes in btrfs-progs 4.1, but off
>>> hand I don't know that they'd affect btrfs check results.
>>>
>>>
>>> Chris Murphy
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
