Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:42642 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932286AbeE1RKy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 13:10:54 -0400
Received: by mail-wr0-f176.google.com with SMTP id w10-v6so21307335wrk.9
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 10:10:53 -0700 (PDT)
Subject: Re: csum failed root raveled during balance
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <5B047817.3040106@gmail.com>
 <e04ab862-abe3-7187-1519-b89776df9362@suse.com> <5B052068.5000608@gmail.com>
 <pan$d9d06$238f0899$805884d5$1c7cb19b@cox.net> <5B053DF2.4030301@gmail.com>
 <34e2ea9c-dc43-af9e-6de1-566e411f7660@gmail.com>
From: ein <ein.net@gmail.com>
Message-ID: <a83bc158-716c-81c9-de43-0caca11ef4e6@gmail.com>
Date: Mon, 28 May 2018 19:10:50 +0200
MIME-Version: 1.0
In-Reply-To: <34e2ea9c-dc43-af9e-6de1-566e411f7660@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2018 01:03 PM, Austin S. Hemmelgarn wrote:
> On 2018-05-23 06:09, ein wrote:
>> On 05/23/2018 11:09 AM, Duncan wrote:
>>> ein posted on Wed, 23 May 2018 10:03:52 +0200 as excerpted:
>>>
>>>>> IMHO the best course of action would be to disable checksumming for
>>>>> you
>>>>> vm files.
>>>>
>>>> Do you mean '-o nodatasum' mount flag? Is it possible to disable
>>>> checksumming for singe file by setting some magical chattr? Google
>>>> thinks it's not possible to disable csums for a single file.
>>>
>>> You can use nocow (-C), but of course that has other restrictions (like
>>> setting it on the files when they're zero-length, easiest done for
>>> existing data by setting it on the containing dir and copying files (no
>>> reflink) in) as well as the nocow effects, and nocow becomes cow1
>>> after a
>>> snapshot (which locks the existing copy in place so changes written to a
>>> block /must/ be written elsewhere, thus the cow1, aka cow the first time
>>> written after the snapshot but retain the nocow for repeated writes
>>> between snapshots).
>>>
>>> But if you're disabling checksumming anyway, nocow's likely the way
>>> to go.
>>
>> Disabling checksumming only may be a way to go - we live without it
>> every day. But nocow @ VM files defeats whole purpose of using BTRFS for
>> me, even with huge performance penalty - backup reasons - I mean few
>> snapshots (20-30), send & receive.
>>
> Setting NOCOW on a file doesn't prevent it from being snapshotted, it
> just prevents COW operations from happening under most normal
> circumstances.  In essence, it prevents COW from happening except for
> writing right after the snapshot.  More specifically, the first write to
> a given block in a file set for NOCOW after taking a snapshot will
> trigger a _single_ COW operation for _only_ that block (unless you have
> autodefrag enabled too), after which that block will revert to not doing
> COW operations on write.  This way, you still get consistent and working
> snapshots, but you also don't take the performance hits from COW except
> right after taking a snapshot.

Yeah, just after I've post it, I've found some Duncan post from 2015,
explaining it, thank you anyway.

Is there anything we can do better in random/write VM workload to speed
the BTRFS up and why?

My settings:

<disk type='file' device='disk'>
      <driver name='qemu' type='raw' cache='none' io='native'/>
      <source file='/var/lib/libvirt/images/db.raw'/>
      <target dev='vda' bus='virtio'/>
      [...]
</disk>

/dev/mapper/raid10-images on /var/lib/libvirt type btrfs
(rw,noatime,nodiratime,compress=lzo:3,ssd,space_cache,autodefrag,subvolid=5,subvol=/)

md1 : active raid10 sdc1[2] sdb2[1] sdd1[3] sda2[0]
      468596736 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 0/4 pages [0KB], 65536KB chunk

CPU: E3-1246 with: VT-x, VT-d, HT, EPT, TSX-NI, AES-NI on debian's
kernel 4.15.0-0.bpo.2-amd64

As far as I understand compress and autodefrag are impacting negatively
for performance (latency), especially autodefrag. I think also that
nodatacow shall also speed things up and it's a must when using qemu and
BTRFS. Is it better to use virtio or virt-scsi with TRIM support?

-- 
PGP Public Key (RSA/4096b):
ID: 0xF2C6EA10
SHA-1: 51DA 40EE 832A 0572 5AD8 B3C0 7AFF 69E1 F2C6 EA10
