Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:36538 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754067AbdECRnc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 13:43:32 -0400
Received: by mail-yw0-f178.google.com with SMTP id l18so88935496ywh.3
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 10:43:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F4778DD1-E0D1-475E-A177-6AA23B56C7CD@redhat.com>
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
 <CAJCQCtQGmQksOmwjmYRVtdBfcY1YT5eY7vSWGgt6oJFcg8HaGQ@mail.gmail.com>
 <2CE52079-1B96-4FB3-8CEF-05FC6D3CB183@redhat.com> <CAJCQCtSp+Udo8qA_ZdY7JUhfmdAFYT7di6JxJ5ELUWi1muQ-og@mail.gmail.com>
 <0E7C728D-E9DD-4E04-81E3-C4F47FCA2DC9@redhat.com> <CAJCQCtSTNm_BjsCQF=Y9TpJD4uWUfPy3k93rfU15OGVR-QuSXQ@mail.gmail.com>
 <F4778DD1-E0D1-475E-A177-6AA23B56C7CD@redhat.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 3 May 2017 11:43:30 -0600
Message-ID: <CAJCQCtTSSSnh9F_iM7Vc261Pt_WqBh1NFi2tLe9miPSSP7uSdg@mail.gmail.com>
Subject: Re: File system corruption, btrfsck abort
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 3, 2017 at 8:17 AM, Christophe de Dinechin
<dinechin@redhat.com> wrote:

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

I see the same pathological behavior. I don't know if it's Windows,
NTFS, or some combination of how Windows+NTFS flushes, and how that
flush gets treated as it passes from guest to host. And I don't know
if qcow2 itself exacerbates it. But it seems fairly clear most every
Windows guest write becomes an extent on Btrfs.

If we consider 3438997 extents, and each extent has an extent data
item, with ~200 items per 16KiB leaf, that's 17194 leaves, and about
270MiB of metadata. For one file; and that's just the extent data
metadata. It doesn't include csums. But anyway there's a lot of churn
not just in the extent data getting written out but how much metadata
is affected by each write and the obsoleting of extents. Pretty much
everything on Btrfs is a write. Even a delete is first a write and
only later is space released.


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

It only works on zero length files. It has to be set at the time the
file is created, which is what -o nocow=on does with qemu-img. If you
wanted to do this with raw files and make it behave on Btrfs pretty
much like it does on any other file system:

touch windows.raw
chattr +C windows.raw
fallocate -l 50g windows.raw

It's not possible to retroactively make a cow file nocow, or a nocow
file cow. You can copy it to a new location such that it inherits +C
(like a new directory). And you can also create a new nocow file, and
then cat the old one into the new one. I haven't tried it but
presumably you can use either 'qemu-img convert' or 'qemu-img dd' to
migrate the data inside a cow qcow2 into a nocow qcow2. I don't know
if you'd do the touch > chattr > qemu-image; or if you'd have qemu-img
create a new one with -o nocow=on and then use the dd command.



-- 
Chris Murphy
