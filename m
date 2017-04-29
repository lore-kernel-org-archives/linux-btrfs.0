Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35970 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166455AbdD2IqU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 04:46:20 -0400
Received: by mail-wm0-f52.google.com with SMTP id u65so58180665wmu.1
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Apr 2017 01:46:19 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: File system corruption, btrfsck abort
From: Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <CAJCQCtSp+Udo8qA_ZdY7JUhfmdAFYT7di6JxJ5ELUWi1muQ-og@mail.gmail.com>
Date: Sat, 29 Apr 2017 10:46:17 +0200
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <0E7C728D-E9DD-4E04-81E3-C4F47FCA2DC9@redhat.com>
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
 <CAJCQCtQGmQksOmwjmYRVtdBfcY1YT5eY7vSWGgt6oJFcg8HaGQ@mail.gmail.com>
 <2CE52079-1B96-4FB3-8CEF-05FC6D3CB183@redhat.com>
 <CAJCQCtSp+Udo8qA_ZdY7JUhfmdAFYT7di6JxJ5ELUWi1muQ-og@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 28 Apr 2017, at 22:09, Chris Murphy <lists@colorremedies.com> wrote:
> 
> On Fri, Apr 28, 2017 at 3:10 AM, Christophe de Dinechin
> <dinechin@redhat.com> wrote:
> 
>> 
>> QEMU qcow2. Host is BTRFS. Guests are BTRFS, LVM, Ext4, NTFS (winXP and
>> win10) and HFS+ (macOS Sierra). I think I had 7 VMs installed, planned to
>> restore another 8 from backups before my previous disk crash. I usually have
>> at least 2 running, often as many as 5 (fedora, ubuntu, winXP, win10, macOS)
>> to cover my software testing needs.
> 
> That is quite a torture test for any file system but more so Btrfs.

Sorry, but could you elaborate why it’s worse for btrfs?

> How are the qcow2 files being created?

In most cases, default qcow2 configuration as given by virt-manager.

> What's the qemu-img create
> command? In particular i'm wondering if these qcow2 files are cow or
> nocow; if they're compressed by Btrfs; and how many fragments they
> have with filefrag.

I suspect they are cow. I’ll check (on the other machine with a similar setup) when I’m back home.


> 
> When I was using qcow2 for backing I used
> 
> qemu-img create -f qcow2 -o preallocation=falloc,nocow=on,lazy_refcounts=on
> 
> But then later I started using fallocated raw files with chattr +C
> applied. And these days I'm just using LVM thin volumes. The journaled
> file systems in a guest cause a ton of backing file fragmentation
> unless nocow is used on Btrfs. I've seen hundreds of thousands of
> extents for a single backing file for a Windows guest.

Are there btrfs commands I could run on a read-only filesystem that would give me this information?

Thanks
Christophe

> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

