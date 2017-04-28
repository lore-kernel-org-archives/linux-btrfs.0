Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:35759 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S642676AbdD1UKA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 16:10:00 -0400
Received: by mail-yw0-f176.google.com with SMTP id u70so36195898ywe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 13:10:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2CE52079-1B96-4FB3-8CEF-05FC6D3CB183@redhat.com>
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
 <CAJCQCtQGmQksOmwjmYRVtdBfcY1YT5eY7vSWGgt6oJFcg8HaGQ@mail.gmail.com> <2CE52079-1B96-4FB3-8CEF-05FC6D3CB183@redhat.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 28 Apr 2017 14:09:59 -0600
Message-ID: <CAJCQCtSp+Udo8qA_ZdY7JUhfmdAFYT7di6JxJ5ELUWi1muQ-og@mail.gmail.com>
Subject: Re: File system corruption, btrfsck abort
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 3:10 AM, Christophe de Dinechin
<dinechin@redhat.com> wrote:

>
> QEMU qcow2. Host is BTRFS. Guests are BTRFS, LVM, Ext4, NTFS (winXP and
> win10) and HFS+ (macOS Sierra). I think I had 7 VMs installed, planned to
> restore another 8 from backups before my previous disk crash. I usually have
> at least 2 running, often as many as 5 (fedora, ubuntu, winXP, win10, macOS)
> to cover my software testing needs.

That is quite a torture test for any file system but more so Btrfs.
How are the qcow2 files being created? What's the qemu-img create
command? In particular i'm wondering if these qcow2 files are cow or
nocow; if they're compressed by Btrfs; and how many fragments they
have with filefrag.

When I was using qcow2 for backing I used

qemu-img create -f qcow2 -o preallocation=falloc,nocow=on,lazy_refcounts=on

But then later I started using fallocated raw files with chattr +C
applied. And these days I'm just using LVM thin volumes. The journaled
file systems in a guest cause a ton of backing file fragmentation
unless nocow is used on Btrfs. I've seen hundreds of thousands of
extents for a single backing file for a Windows guest.

-- 
Chris Murphy
