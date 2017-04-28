Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33471 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035395AbdD1D6y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 23:58:54 -0400
Received: by mail-yw0-f169.google.com with SMTP id 203so25382992ywe.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 20:58:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 27 Apr 2017 21:58:52 -0600
Message-ID: <CAJCQCtQGmQksOmwjmYRVtdBfcY1YT5eY7vSWGgt6oJFcg8HaGQ@mail.gmail.com>
Subject: Re: File system corruption, btrfsck abort
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 25, 2017 at 11:50 AM, Christophe de Dinechin
<dinechin@redhat.com> wrote:

>
> The last filesystem corruption is documented here: https://bugzilla.redhat.com/show_bug.cgi?id=1444821. The dmesg log is in there.

And also from the bug:
>How reproducible: Seen at least 4 times on 3 different disks and 2 different systems.


I've been using Fedora and Btrfs on 1/2 dozen different kinds of
hardware since around Fedora 13. The oldest file systems are about 2
years old. I've not seen file system corruption. So I'd say there's
some kind of workload that's helping to trigger it or it's hardware
related; that it's happening on multiple systems makes me wonder if
it's power related.



>
> The btrfsck crash is here: https://bugzilla.redhat.com/show_bug.cgi?id=1435567. I have two crash modes: either an abort or a SIGSEGV. I checked that both still happens on master as of today.

The btrfs check crash is another matter. I've seen it crash many
times, but the more recent versions are more reliable and haven't seen
a crash lately.



> I don’t know if this is relevant at all, but all the machines that failed that way were used to run VMs with KVM/QEMU. DIsk activity tends to be somewhat intense on occasions, since the VMs running there are part of a personal Jenkins ring that automatically builds various projects. Nominally, there are between three and five guests running (Windows XP, WIndows 10, macOS, Fedora25, Ubuntu 16.04).


I do run VM's quite often with all of my setups but rarely two
concurrently and never three or more. So, hmmm. And are the VM's
backed by a qemu image on Btrfs? Or LVM?


-- 
Chris Murphy
