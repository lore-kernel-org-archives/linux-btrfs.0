Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:59910 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934361AbcKJQbu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 11:31:50 -0500
Subject: Re: [PATCH] Btrfs: deal with existing encompassing extent map in
 btrfs_get_extent()
To: Omar Sandoval <osandov@osandov.com>
References: <262a1e171d091626edbd23c637cb138ba9d84ed8.1478733376.git.osandov@fb.com>
 <58248E27.7080601@applied-asynchrony.com> <20161110153720.GA29712@vader>
 <582499E8.5090504@applied-asynchrony.com> <20161110162034.GA2847@vader>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <5824A0F3.1080702@applied-asynchrony.com>
Date: Thu, 10 Nov 2016 17:31:47 +0100
MIME-Version: 1.0
In-Reply-To: <20161110162034.GA2847@vader>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/16 17:20, Omar Sandoval wrote:
> On Thu, Nov 10, 2016 at 05:01:44PM +0100, Holger Hoffstätte wrote:
>> On 11/10/16 16:37, Omar Sandoval wrote:
>>> On Thu, Nov 10, 2016 at 04:11:35PM +0100, Holger Hoffstätte wrote:
>>>> On 11/10/16 00:26, Omar Sandoval wrote:
>>>>> From: Omar Sandoval <osandov@fb.com>
>>>>>
>>>>> My QEMU VM was seeing inexplicable I/O errors that I tracked down to
>>>>> errors coming from the qcow2 virtual drive in the host system. The qcow2
>>>>> file is a nocow file on my Btrfs drive, which QEMU opens with O_DIRECT.
>>>>> Every once in awhile, pread() or pwrite() would return EEXIST, which
>>>>> makes no sense. This turned out to be a bug in btrfs_get_extent().
>>>>>
>>>>> Commit 8dff9c853410 ("Btrfs: deal with duplciates during extent_map
>>>>> insertion in btrfs_get_extent") fixed a case in btrfs_get_extent() where
>>>>> two threads race on adding the same extent map to an inode's extent map
>>>>> tree. However, if the added em is merged with an adjacent em in the
>>>>> extent tree, then we'll end up with an existing extent that is not
>>>>> identical to but instead encompasses the extent we tried to add. When we
>>>>> call merge_extent_mapping() to find the nonoverlapping part of the new
>>>>> em, the arithmetic overflows because there is no such thing. We then end
>>>>> up trying to add a bogus em to the em_tree, which results in a EEXIST
>>>>> that can bubble all the way up to userspace.
>>>>>
>>>>> Fix it by extending the identical extent map special case.
>>>>>
>>>>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>>>>> ---
>>>>> Applies to 4.9-rc4.
>>>>>
>>>>> Here [1] is a reproducer for this bug that doesn't involve firing up a
>>>>> QEMU VM. Also, a big shoutout to BCC [2] and BPF for making it possible
>>>>> to debug this on my laptop without compiling a custom kernel and
>>>>> rebooting just to add printks [3].
>>>>>
>>>>> 1: https://gist.github.com/osandov/d08aabe5d4dec15517e9fde17012fd3b
>>>>
>>>> I can't really make this reproducer fail. It builds and runs fine, but just
>>>> exits with no messages (other than the one about drop_caches in dmesg).
>>>> It creates the 1MB file and always returns 0. Ideas?
>>>>
>>>> -h
>>>
>>> It's a race condition, so it doesn't happen 100% of the time. I imagine
>>> it depends on the storage speed, as well. On my laptop, which is
>>> dm-crypt on top of an SSD, it works about 50% of the time. Could you
>>> just try running it 100 times or something and see if it fails?
>>
>> $for i ($(seq 1 1000)) ./pread_eexist_repro /mnt/test/$i || echo "fail"
>>
>> ..couple of thousand runs without problem, only lots of fallocating and
>> cache dropping.
>>
>> Oh well, I tried. :)
>>
>> -h
> 
> Just out of curiousity, what kind of disk were you trying this on? I've
> only been able to trigger it on my laptop and a VM running on my laptop.

Tried on both an SSD and an old slowpoke 2.5" rotational disk on USB2.
But I also have a ton of other patches and a custom CPU scheduler, so
everything it likely my fault anyway. Don't sweat it. :)

>From what I can tell the explanation of the problem and the change itself
make sense. Would have been nice to be able to repro.

cheers,

-h

