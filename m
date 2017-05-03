Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33847 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdECOuB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 10:50:01 -0400
Received: by mail-io0-f176.google.com with SMTP id k91so13895693ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 07:50:00 -0700 (PDT)
Subject: Re: File system corruption, btrfsck abort
To: Christophe de Dinechin <dinechin@redhat.com>,
        Chris Murphy <lists@colorremedies.com>
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
 <CAJCQCtQGmQksOmwjmYRVtdBfcY1YT5eY7vSWGgt6oJFcg8HaGQ@mail.gmail.com>
 <2CE52079-1B96-4FB3-8CEF-05FC6D3CB183@redhat.com>
 <CAJCQCtSp+Udo8qA_ZdY7JUhfmdAFYT7di6JxJ5ELUWi1muQ-og@mail.gmail.com>
 <0E7C728D-E9DD-4E04-81E3-C4F47FCA2DC9@redhat.com>
 <CAJCQCtSTNm_BjsCQF=Y9TpJD4uWUfPy3k93rfU15OGVR-QuSXQ@mail.gmail.com>
 <F4778DD1-E0D1-475E-A177-6AA23B56C7CD@redhat.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <204956e4-4066-dd7e-9a00-bfb08027e796@gmail.com>
Date: Wed, 3 May 2017 10:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <F4778DD1-E0D1-475E-A177-6AA23B56C7CD@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-03 10:17, Christophe de Dinechin wrote:
>
>> On 29 Apr 2017, at 21:13, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> On Sat, Apr 29, 2017 at 2:46 AM, Christophe de Dinechin
>> <dinechin@redhat.com> wrote:
>>>
>>>> On 28 Apr 2017, at 22:09, Chris Murphy <lists@colorremedies.com> wrote:
>>>>
>>>> On Fri, Apr 28, 2017 at 3:10 AM, Christophe de Dinechin
>>>> <dinechin@redhat.com> wrote:
>>>>
>>>>>
>>>>> QEMU qcow2. Host is BTRFS. Guests are BTRFS, LVM, Ext4, NTFS (winXP and
>>>>> win10) and HFS+ (macOS Sierra). I think I had 7 VMs installed, planned to
>>>>> restore another 8 from backups before my previous disk crash. I usually have
>>>>> at least 2 running, often as many as 5 (fedora, ubuntu, winXP, win10, macOS)
>>>>> to cover my software testing needs.
>>>>
>>>> That is quite a torture test for any file system but more so Btrfs.
>>>
>>> Sorry, but could you elaborate why it’s worse for btrfs?
>>
>>
>> Copy on write. Four of your five guests use non-cow filesystems, so
>> any overwrite, think journal writes, are new extent writes in Btrfs.
>> Nothing is overwritten in Btrfs. Only after the write completes are
>> the stale extents released. So you get a lot of fragmentation, and all
>> of these tasks you're doing become very metadata heavy workloads.
>
> Makes sense. Thanks for explaining.
>
>
>> However, what you're doing should work. The consequence should only be
>> one of performance, not file system integrity. So your configuration
>> is useful for testing and making Btrfs better.
>
> Yes. I just received a new machine, which is intended to become my primary host. That one I installed with ext4, so that I can keep pushing btrfs on my other two Linux hosts. Since I don’t care much about performance of the VMs either (they are build bots for a Jenkins setup), I can leave them in the current sub-optimal configuration.
On the note of performance, you can make things slightly better by 
defragmenting on a regular (weekly is what I would suggest) basis.  Make 
sure to defrag inside the guest first, then defrag the disk image file 
itself on the host if you do this though, as that will help ensure an 
optimal layout.  FWIW, tools like Ansible or Puppet are great for 
coordinating this.
>
>>
>>>> How are the qcow2 files being created?
>>>
>>> In most cases, default qcow2 configuration as given by virt-manager.
>>>
>>>> What's the qemu-img create
>>>> command? In particular i'm wondering if these qcow2 files are cow or
>>>> nocow; if they're compressed by Btrfs; and how many fragments they
>>>> have with filefrag.
>>>
>>> I suspect they are cow. I’ll check (on the other machine with a similar setup) when I’m back home.
>>
>> Check the qcow2 files with filefrag and see how many extents they
>> have. I'll bet they're massively fragmented.
>
> Indeed:
>
> fedora25.qcow2: 28358 extents found
> mac_hdd.qcow2: 79493 extents found
> ubuntu14.04-64.qcow2: 35069 extents found
> ubuntu14.04.qcow2: 240 extents found
> ubuntu16.04-32.qcow2: 81 extents found
> ubuntu16.04-64.qcow2: 15060 extents found
> ubuntu16.10-64.qcow2: 228 extents found
> win10.qcow2: 3438997 extents found
> winxp.qcow2: 66657 extents found
>
> I have no idea why my Win10 guest is so much worse than the others. It’s currently one of the least used, at least it’s not yet operating regularly in my build ring… But I had noticed that the installation of Visual Studio had taken quite a bit of time.
Windows 10 does a lot more background processing than XP, and a lot of 
it hits the disk (although most of what you are seeing is probably side 
effects from the automatically scheduled defrag job that Windows 10 
seems to have).  It also appears to have a different allocator in the 
NTFS driver which prefers to spread data under certain circumstances, 
and VM's appear to be one such situation.
>
>>
>>>> When I was using qcow2 for backing I used
>>>>
>>>> qemu-img create -f qcow2 -o preallocation=falloc,nocow=on,lazy_refcounts=on
>>>>
>>>> But then later I started using fallocated raw files with chattr +C
>>>> applied. And these days I'm just using LVM thin volumes. The journaled
>>>> file systems in a guest cause a ton of backing file fragmentation
>>>> unless nocow is used on Btrfs. I've seen hundreds of thousands of
>>>> extents for a single backing file for a Windows guest.
>>>
>>> Are there btrfs commands I could run on a read-only filesystem that would give me this information?
>>
>> lsattr
>
> Hmmm. Does that even work on BTRFS? I get this, even after doing a chattr +C on one of the files.
>
> ------------------- fedora25.qcow2
> ------------------- mac_hdd.qcow2
> ------------------- ubuntu14.04-64.qcow2
> ------------------- ubuntu14.04.qcow2
> ------------------- ubuntu16.04-32.qcow2
> ------------------- ubuntu16.04-64.qcow2
> ------------------- ubuntu16.10-64.qcow2
> ------------------- win10.qcow2
> ------------------- winxp.qcow2
These files wouldn't have been created with the NOCOW attribute by 
default, as QEMU doesn't know about it.  To convert them, you would have 
to create a new empty file, set that attribute, then use something like 
cp or dd to copy the data into the new file, then rename it over-top of 
the old one.  Setting these NOCOW may not help as much as it does for 
pre-allocated raw image files though.

