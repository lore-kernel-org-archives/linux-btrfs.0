Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35517 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752405AbdECOR3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 10:17:29 -0400
Received: by mail-wm0-f51.google.com with SMTP id w64so148564207wma.0
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 07:17:28 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: File system corruption, btrfsck abort
From: Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <CAJCQCtSTNm_BjsCQF=Y9TpJD4uWUfPy3k93rfU15OGVR-QuSXQ@mail.gmail.com>
Date: Wed, 3 May 2017 16:17:26 +0200
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <F4778DD1-E0D1-475E-A177-6AA23B56C7CD@redhat.com>
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
 <CAJCQCtQGmQksOmwjmYRVtdBfcY1YT5eY7vSWGgt6oJFcg8HaGQ@mail.gmail.com>
 <2CE52079-1B96-4FB3-8CEF-05FC6D3CB183@redhat.com>
 <CAJCQCtSp+Udo8qA_ZdY7JUhfmdAFYT7di6JxJ5ELUWi1muQ-og@mail.gmail.com>
 <0E7C728D-E9DD-4E04-81E3-C4F47FCA2DC9@redhat.com>
 <CAJCQCtSTNm_BjsCQF=Y9TpJD4uWUfPy3k93rfU15OGVR-QuSXQ@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 29 Apr 2017, at 21:13, Chris Murphy <lists@colorremedies.com> wrote:
> 
> On Sat, Apr 29, 2017 at 2:46 AM, Christophe de Dinechin
> <dinechin@redhat.com> wrote:
>> 
>>> On 28 Apr 2017, at 22:09, Chris Murphy <lists@colorremedies.com> wrote:
>>> 
>>> On Fri, Apr 28, 2017 at 3:10 AM, Christophe de Dinechin
>>> <dinechin@redhat.com> wrote:
>>> 
>>>> 
>>>> QEMU qcow2. Host is BTRFS. Guests are BTRFS, LVM, Ext4, NTFS (winXP and
>>>> win10) and HFS+ (macOS Sierra). I think I had 7 VMs installed, planned to
>>>> restore another 8 from backups before my previous disk crash. I usually have
>>>> at least 2 running, often as many as 5 (fedora, ubuntu, winXP, win10, macOS)
>>>> to cover my software testing needs.
>>> 
>>> That is quite a torture test for any file system but more so Btrfs.
>> 
>> Sorry, but could you elaborate why it’s worse for btrfs?
> 
> 
> Copy on write. Four of your five guests use non-cow filesystems, so
> any overwrite, think journal writes, are new extent writes in Btrfs.
> Nothing is overwritten in Btrfs. Only after the write completes are
> the stale extents released. So you get a lot of fragmentation, and all
> of these tasks you're doing become very metadata heavy workloads.

Makes sense. Thanks for explaining.


> However, what you're doing should work. The consequence should only be
> one of performance, not file system integrity. So your configuration
> is useful for testing and making Btrfs better.

Yes. I just received a new machine, which is intended to become my primary host. That one I installed with ext4, so that I can keep pushing btrfs on my other two Linux hosts. Since I don’t care much about performance of the VMs either (they are build bots for a Jenkins setup), I can leave them in the current sub-optimal configuration.

> 
>>> How are the qcow2 files being created?
>> 
>> In most cases, default qcow2 configuration as given by virt-manager.
>> 
>>> What's the qemu-img create
>>> command? In particular i'm wondering if these qcow2 files are cow or
>>> nocow; if they're compressed by Btrfs; and how many fragments they
>>> have with filefrag.
>> 
>> I suspect they are cow. I’ll check (on the other machine with a similar setup) when I’m back home.
> 
> Check the qcow2 files with filefrag and see how many extents they
> have. I'll bet they're massively fragmented.

Indeed:

fedora25.qcow2: 28358 extents found
mac_hdd.qcow2: 79493 extents found
ubuntu14.04-64.qcow2: 35069 extents found
ubuntu14.04.qcow2: 240 extents found
ubuntu16.04-32.qcow2: 81 extents found
ubuntu16.04-64.qcow2: 15060 extents found
ubuntu16.10-64.qcow2: 228 extents found
win10.qcow2: 3438997 extents found
winxp.qcow2: 66657 extents found

I have no idea why my Win10 guest is so much worse than the others. It’s currently one of the least used, at least it’s not yet operating regularly in my build ring… But I had noticed that the installation of Visual Studio had taken quite a bit of time.

> 
>>> When I was using qcow2 for backing I used
>>> 
>>> qemu-img create -f qcow2 -o preallocation=falloc,nocow=on,lazy_refcounts=on
>>> 
>>> But then later I started using fallocated raw files with chattr +C
>>> applied. And these days I'm just using LVM thin volumes. The journaled
>>> file systems in a guest cause a ton of backing file fragmentation
>>> unless nocow is used on Btrfs. I've seen hundreds of thousands of
>>> extents for a single backing file for a Windows guest.
>> 
>> Are there btrfs commands I could run on a read-only filesystem that would give me this information?
> 
> lsattr

Hmmm. Does that even work on BTRFS? I get this, even after doing a chattr +C on one of the files.

------------------- fedora25.qcow2
------------------- mac_hdd.qcow2
------------------- ubuntu14.04-64.qcow2
------------------- ubuntu14.04.qcow2
------------------- ubuntu16.04-32.qcow2
------------------- ubuntu16.04-64.qcow2
------------------- ubuntu16.10-64.qcow2
------------------- win10.qcow2
------------------- winxp.qcow2

Thanks
Christophe

> 
> 
> -- 
> Chris Murphy

