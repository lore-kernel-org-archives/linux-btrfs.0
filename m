Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:44657 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbeENK3j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 06:29:39 -0400
Received: by mail-oi0-f47.google.com with SMTP id e80-v6so10163462oig.11
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 03:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d7c78e64-0659-6552-8e7a-8dbbc9b4df72@gmx.com>
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com> <CA+X5Wn5J4TBx-Fa3WLrBPULRiGNa7m_4U9YS6LDvUyVT1TVhqg@mail.gmail.com>
 <d7c78e64-0659-6552-8e7a-8dbbc9b4df72@gmx.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 14 May 2018 06:29:38 -0400
Message-ID: <CA+X5Wn6853b0O164U-fLP4CeXii62HpTLUkMrW_-b2U2iBM5Yw@mail.gmail.com>
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 2:36 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> OK, I could reproduce it now.
>
> Just mount with -o nodatasum, then create a file.
> Remount with compress-force=lzo, then write something.
>
> So at least btrfs should disallow such thing.
>
> Thanks,
> Qu

Would the corrupted dump and correct one of the file, and kernel with
kasan output still help?  Or, with what you reproduced, do you have
what you need?


On Mon, May 14, 2018 at 1:30 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> So there is something wrong that btrfs allows compressed data to be
> generated for such file.
> (Could not reproduce the same behavior with 4.16 kernel, could such
> problem happens in older kernels? Or just get fixed recently?)
>
> Then some corruption screwed up the compressed data, and when we
> decompress, the kernel is screwed up.

In this thread, Chris Murphy noted systemd sets the "C" attribute, and
discussed what sounds to me like what happened here: "Usually nocow
also means no compression. But in the archives is a thread where I
found that compression can be forced on nocow if the file is submitted
for defragmentation and either the volume is mounted with compression
or the file has inherited chattr +c (I don't remember which or
possibly both). And systemd does submit rotated logs for
defragmentation."



(If you don't need the dumps and kernel kasan output, you can skip the
rest of this reply)



> Yep, even the last case it still looks like that it's kernel memory get
> corrupted.
>
> From the thread, since you have already located the corrupted mirror,
> would you please provide the corrupted dump along with correct one?
>
> It would help a lot for us to under stand what's going on.

Absolutely.  I'm not sure how to best get you that, though.

"filefrag -v" on one of the files can be seen here:
https://bugzilla.kernel.org/attachment.cgi?id=275953

It lists 58 fragments.

filefrag lists the ending offsets and length based on the uncompressed
sizes.  filefrag doesn't account for the compression.

So, in this thread, I compared the first 4k of fragments 0-57 on each
disk and found all the corruption was on disk 1.  (And the entire
207*4096 bytes on fragment 58.)  Grabbing more than 4k of each
fragment brings in data from other files.  So, I might have compared
all of the data (fragments 0-57 are 128k uncompressed, and at least
fragment 0 uncompressed does lzop down to about 2k, so perhaps all the
other 128k fragments compress to within 4k, but maybe not) but this
might not have grabbed all the data.

I could give you (56) 128k, (1) 68k, and (1) 828k fragments, but
they'd include extra data not involved, so you'd have to find a way to
use them, and without the metadata saying how many bytes of each
fragment to use, it might not be easy to put together.  (Maybe
chopping off all the trailing 0's in each fragment would do the
trick.)  Maybe the first 9 byte header on each fragment encodes the
length actually used?

If this is useful to you, I'd be happy to provide it, along with the
correct one.

If there's a better way than this, I'd be happy to do that instead.  I
of course can't just copy the file, so have to do something like dd or
"btrfs-map-logical -o".  "btrfs-map-logical -o" can't automatically
grab the proper length, because it needs a size argument, and if not
given, defaults to the 16k nodesize.

> The dump indicates the same conclusion you reached.
> The inode has NODATACOW NODATASUM flag, which means it should not has
> csum nor has data compressed.
> While in fact we have tons of compressed extents.
>
> But the following fiemap result also shows that these extents get
> shared. This could happen when there is a snapshot.

I do run snapper.

> To pindown the lzo decompress corruption, kasan would be a nice try.
> However this means you need to enable it at compile time, and recompile
> a kernel.
> Not to mention kasan has a great impact on performance.
>
> But it should provide more info before memory get corrupted.

Sure, it's compiling.  I'll probably be available to run it and send
results in 14 hours, if needed.
