From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH 0/5] btrfs: Add lzo compression support
Date: Mon, 15 Nov 2010 12:55:29 -0600
Message-ID: <AANLkTi=pRg5eFz+KS7+2k94FraofwYJitY74TVdbCOzs@mail.gmail.com>
References: <4CC52D9A.3030709@cn.fujitsu.com>
	<20101026021341.GW18818@think>
	<4CC63E36.8050105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CC63E36.8050105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 25, 2010 at 9:34 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Chris Mason wrote:
>> On Mon, Oct 25, 2010 at 03:11:22PM +0800, Li Zefan wrote:
>>> Lzo is a much faster compression algorithm than gzib, so would allo=
w
>>> more users to enable transparent compression, and some users can
>>> choose from compression ratio and compression speed.
>>
>> This is also much smaller than I expected, really nice. =A0It looks =
like
>> older kernels won't properly deal (nicely give EIO) with lzo compres=
sed
>> files?
>>
>> We can add compatbits to deal with that if it is the case.
>>
>
> I forgot compatibility issue with older kernels..
>
> Though I didn't test older kernels, I don't think they can deal with =
lzo
> compressed files properly, at least not for inlined extents, in which
> case I think btrfs will just show compressed data to the users.
>
> So yes, an incompat flag is needed.

I've been testing this set of patches on a 2.6.36 kernel with the
latest btrfs-unstable patches, and I wanted to provide my positive
feedback.

The lzo compression patches worked as expected, and I did not
encounter any stability problems in my testing (which mainly consisted
of decompressing a root partition archive and doing some compiling
chores in a chroot environment on that drive).

I did some crude benchmarking on decompressing an archived root
partition to an empty btrfs drive, and my results were similar to the
results posted by Li Zefan in the original post.  The lzo compression
did not compress quite as well as zlib, but was much faster.

I did some test mounting of a lzo-compressed partition with an older
non-lzo-patched kernel, and as expected, the contents of the files
were garbled.  But I did not encounter kernel oops or other issues
when trying to read the garbled files.

I also wanted to confirm that my other zlib-compressed partitions did
not encounter any issues when bouncing back and forth between a
lzo-patched kernel and older kernels.  As expected, I did not see any
issues in the partitions that had only been mounted with zlib
compression.

You'll want an incompat flag as indicated in previous posts, but I
look forward to seeing lzo compression in the future.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
