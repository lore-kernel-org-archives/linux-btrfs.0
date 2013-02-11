Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:57005 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab3BKOIZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 09:08:25 -0500
Received: by mail-vb0-f54.google.com with SMTP id l1so3801720vba.27
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2013 06:08:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130211132700.GP12339@twin.jikos.cz>
References: <CAMqPLXVezXkqMPn3R56HTVkgPTN859fjukyr06dgtCFPme0Lug@mail.gmail.com>
	<20130211132700.GP12339@twin.jikos.cz>
Date: Mon, 11 Feb 2013 15:08:11 +0100
Message-ID: <CAMqPLXXgN6zN_wj-g-ALebeEhhujLSB4T+yrQ0Bnc9MTDeD2DQ@mail.gmail.com>
Subject: Re: btrfs-progs 0.20rc1.1, linux 3.7.6 - new filesystem: failed to
 recover relocation
From: Sjon Hortensius <Sjon@hortensius.net>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 2:27 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Feb 11, 2013 at 02:09:56PM +0100, Sjon Hortensius wrote:
>> I have just completed installing an archlinux machine with 2 btrfs
>> partitions, one works fine (the rootfs), the other one I cannot mount.
>> Even after recreating the filesystem I still cannot mount it. I
>> receive te following output in my dmesg:
>>
>> [ 6526.037089] device fsid 74cc8eb8-f60a-4797-9ab3-0c8ac4fe847f devid
>> 1 transid 3 /dev/vdb1
>> [ 6526.037763] btrfs: disk space caching is enabled
>> [ 6526.038415] btrfs: failed to recover relocation
>> [ 6526.039716] btrfs: open_ctree failed
>
> What was the size of the filesystem?

The first filesystem (of which I created the image) was ~ 20 GiB; the
dd dump is from a 100 MiB partition.

>> btrfsck reports no errors. An image of this filesystem can be found
>> here: http://home.react.nl/~sjon/bug-reports/btrfs/btrfs-failed-to-recover-relocation
>> (29 KiB)
>
> Restoring the image produces a 4MB file, which is kind of too small,
> there's a patch for mkfs to prevent creating such a fs. I'll get to
> adding it to progs integration soon.
>
> david

While debugging this my vm-host began throwing segfaults as well, so I
think this problem was caused by something else (namely this:
https://bugzilla.redhat.com/show_bug.cgi?id=893854).

Thanks anyway.
