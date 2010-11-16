From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] btrfs: Add lzo compression support
Date: Tue, 16 Nov 2010 08:57:19 +0800
Message-ID: <4CE1D6EF.4070205@cn.fujitsu.com>
References: <4CC52D9A.3030709@cn.fujitsu.com>	<20101026021341.GW18818@think>	<4CC63E36.8050105@cn.fujitsu.com> <AANLkTi=pRg5eFz+KS7+2k94FraofwYJitY74TVdbCOzs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=pRg5eFz+KS7+2k94FraofwYJitY74TVdbCOzs@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Harder wrote:
> On Mon, Oct 25, 2010 at 9:34 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Chris Mason wrote:
>>> On Mon, Oct 25, 2010 at 03:11:22PM +0800, Li Zefan wrote:
>>>> Lzo is a much faster compression algorithm than gzib, so would allow
>>>> more users to enable transparent compression, and some users can
>>>> choose from compression ratio and compression speed.
>>> This is also much smaller than I expected, really nice.  It looks like
>>> older kernels won't properly deal (nicely give EIO) with lzo compressed
>>> files?
>>>
>>> We can add compatbits to deal with that if it is the case.
>>>
>> I forgot compatibility issue with older kernels..
>>
>> Though I didn't test older kernels, I don't think they can deal with lzo
>> compressed files properly, at least not for inlined extents, in which
>> case I think btrfs will just show compressed data to the users.
>>
>> So yes, an incompat flag is needed.
> 
> I've been testing this set of patches on a 2.6.36 kernel with the
> latest btrfs-unstable patches, and I wanted to provide my positive
> feedback.
> 
> The lzo compression patches worked as expected, and I did not
> encounter any stability problems in my testing (which mainly consisted
> of decompressing a root partition archive and doing some compiling
> chores in a chroot environment on that drive).
> 
> I did some crude benchmarking on decompressing an archived root
> partition to an empty btrfs drive, and my results were similar to the
> results posted by Li Zefan in the original post.  The lzo compression
> did not compress quite as well as zlib, but was much faster.
> 
> I did some test mounting of a lzo-compressed partition with an older
> non-lzo-patched kernel, and as expected, the contents of the files
> were garbled.  But I did not encounter kernel oops or other issues
> when trying to read the garbled files.
> 
> I also wanted to confirm that my other zlib-compressed partitions did
> not encounter any issues when bouncing back and forth between a
> lzo-patched kernel and older kernels.  As expected, I did not see any
> issues in the partitions that had only been mounted with zlib
> compression.
> 
> You'll want an incompat flag as indicated in previous posts, but I
> look forward to seeing lzo compression in the future.
> 

Thanks for testing!

I had been occupied by other things, so have been silent on this.
Actually I've added the incompat flag, but haven't done userspace
programs.

I'm setting up a git tree, and will send out a pull request to
Chris this week. (probabaly)

And I think I can add your Tested-by in the whole patchset? Except
for the ioctl change, which I guess you didn't test.

We really need more review and test for btrfs patches, so what
you've done is really appreciatated. :)

--
Li Zefan
