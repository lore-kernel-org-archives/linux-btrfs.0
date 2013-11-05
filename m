Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:49069 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab3KEMhw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 07:37:52 -0500
Received: by mail-vc0-f175.google.com with SMTP id ht10so5548710vcb.34
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 04:37:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201311052316.34979.russell@coker.com.au>
References: <201311051224.44255.russell@coker.com.au>
	<CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
	<201311052316.34979.russell@coker.com.au>
Date: Tue, 5 Nov 2013 13:37:50 +0100
Message-ID: <CAD_cGvHFQNom6RZaKu8LmEfuj_wjeqUp2siTVtapqFcyGzvKgg@mail.gmail.com>
Subject: Re: csum failure messages
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I gave up on getting the filesystem to a concistent state, but my
corruption was much more severe than yours. Several 100 000's. As the
fs was still usable and mountable I just moved all the files to
another filesystem, patched the kernel recreated the original btrfs fs
and ran a rebalance. This time without issues because of the patch. As
the corrupt files were rtorrent files in my case I could just rehash
the torrents and make rtorrent redownload the corrupt blocks. Very
lucky indeed. The other files I could verify against backup.

Luckily the reason for the rebalance in the first place was to add
another 16TB of disk to the RAID10 array, so I just happened to have
enough temporary storage lying around. After patching the kernel and
rebalance I now have a 32TB btrfs RAID10 volume.
Mvh

Hans-Kristian Bakke


On 5 November 2013 13:16, Russell Coker <russell@coker.com.au> wrote:
> On Tue, 5 Nov 2013, "Hans-Kristian Bakke" <hkbakke@gmail.com> wrote:
>> As you were in the process of a rebalance these errors may actually be
>> caused by this serious bug "Btrfs: relocate csums properly with
>> prealloc extents".
>>
>> I hit that myself with several preallocated files made by rtorrent
>> during a rebalance and I lost several huge files as a consequence. The
>> only way I could rebalance without large scale corruptions was to
>> manually patch the 3.11.6 kernel with the small patch that fixes the
>> issue.
>> For some reason this patch is not pushed upstream yet. I think that is
>> strange as it leads to corruption and actual data loss and it is 100%
>> reproducible with preallocated files. Only systemd logs is mentioned
>> in the bug reports, but in my case it was actually hitting several
>> terabytes of files created by rtorrent.
>
> I run systemd to I guess it's the systemd logs.  That's fortunate as such logs
> aren't important to me.  Thanks for providing this information.
>
> I've just run a scrub and I saw the following output.  There was nothing
> useful or apparently relevant in the kernel message log either.  So scrub is
> just telling me that there are 57 errors without giving me a clue as to which
> files might need to be restored from backup.
>
> # btrfs scrub start -B /
> scrub done for c55218a6-abb5-4e35-9a20-33fb1fa05879
>         scrub started at Tue Nov  5 11:32:03 2013 and finished after 6762
> seconds
>         total bytes scrubbed: 140.06GB with 57 errors
>         error details: csum=57
>         corrected errors: 0, uncorrectable errors: 57, unverified errors: 0
>
> I can imagine a balance operation being unable to conveniently display all the
> data that one might desire.  But a scrub really should go through everything
> and should know where the inconsistencies are.  In this case the scrub gave me
> less information than the balance.
>
> I presume that my filesystem is still corrupt.
>
> --
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
