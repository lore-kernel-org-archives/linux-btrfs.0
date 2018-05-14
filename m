Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:37559 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbeENElm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 00:41:42 -0400
Received: by mail-ot0-f181.google.com with SMTP id 77-v6so12773196otd.4
        for <linux-btrfs@vger.kernel.org>; Sun, 13 May 2018 21:41:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com>
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 14 May 2018 00:41:41 -0400
Message-ID: <CA+X5Wn5J4TBx-Fa3WLrBPULRiGNa7m_4U9YS6LDvUyVT1TVhqg@mail.gmail.com>
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 13, 2018 at 10:08 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2018年05月12日 13:08, james harvey wrote:
>> Hardware is fine.  Passes memtest86+ in SMP mode.  Works fine on all
>> other files.
>>
>>
>>
>> [  381.869940] BUG: unable to handle kernel paging request at 0000000000390e50
>> [  381.870881] BTRFS: decompress failed
>> [  381.891775] IP: rebalance_domains+0x8a/0x2c0
>
> The interesting part here is, btrfs is not showing up the call trace,
> not even lzo code.
> (Despite of the "decompress failed" message).
> Maybe some corrupted data is screwing up some random kernel memory?

I've been surprised by this too.  I've seen a few "styles" of crashes from this.

The fuller version of the one I posted in original post:
https://bugzilla.kernel.org/attachment.cgi?id=275949

One that starts with a "general protection fault":
https://bugzilla.kernel.org/attachment.cgi?id=275951

And my most recent version, starts with "BTRFS: decompress failed"
then "BUG: unable to handle kernel NULL pointer dereference at
0000000000000001":
https://bugzilla.kernel.org/attachment.cgi?id=275961

This latest one does have a call trace including btrfs.  The top of
the call trace is "end_compressed_bio_read+0x34e/0x3d0 [btrfs]", and
although it includes the word compressed, I'm not sure that's actually
having to do with lzo compression.  The call stack doesn't scream that
to me.

It seems like when the invalid decompression happens, that code itself
doesn't give any kernel errors, but the rest of the kernel starts
spazzing.

I've replicated this probably about 15 times now.  Only happens on
these files that have inconsistent mirrored data.



> Would you please get the inode number of that corrupted files, and throw
> it through btrfs-debug-tree?
>
> # btrfs-debug-tree -t <subvol_id> <device> | grep -A 50 \(<INO>
>
> This is the preferred method as it would provide all the details we
> need. But since it could contain sensitive info like filename, please
> double check before posting it.

# ls -i system@00fa3c0596e64d2e84096520ca46f008-0000000000000001-00053cd2c1756577.journal
291489 system@00fa3c0596e64d2e84096520ca46f008-0000000000000001-00053cd2c1756577.journal

# ls -i user-1000@b70add0ef010457d933fec23a2afa48a-0000000000000495-00053b6b6e65e9cf.journal
72267 user-1000@b70add0ef010457d933fec23a2afa48a-0000000000000495-00053b6b6e65e9cf.journal

# btrfs-debug-tree -t 5 /dev/lvm/newMain1 | grep -A 50 \(291489 >
debug.tree.291489
Available at: http://termbin.com/kegj

# btrfs-debug-tree -t 5 /dev/lvm/newMain1 | grep -A 50 \(72267 >
debug.tree.72267
Available at: http://termbin.com/xhdc



> Or fiemap of that file could also help:
>
> # xfs_io -c "fiemap -v" <corrupted_file>
>
> This is completely safe, but I'm not 100% sure about if the info is enough.

# xfs_io -c "fiemap -v"
system@00fa3c0596e64d2e84096520ca46f008-0000000000000001-00053cd2c1756577.journal
Available at: http://termbin.com/nsej

# xfs_io -c "fiemap -v"
system@00fa3c0596e64d2e84096520ca46f008-0000000000000001-00053cd2c1756577.journal
Available at: http://termbin.com/4fiz
