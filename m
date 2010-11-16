From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH 0/5] btrfs: Add lzo compression support
Date: Tue, 16 Nov 2010 12:51:35 -0600
Message-ID: <AANLkTimc3MjT2GEmvZ02q028zX5v1hKBYZwseA=qS-VA@mail.gmail.com>
References: <4CC52D9A.3030709@cn.fujitsu.com>
	<20101026021341.GW18818@think>
	<4CC63E36.8050105@cn.fujitsu.com>
	<AANLkTi=pRg5eFz+KS7+2k94FraofwYJitY74TVdbCOzs@mail.gmail.com>
	<4CE1D6EF.4070205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE1D6EF.4070205@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 15, 2010 at 6:57 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Mitch Harder wrote:
>> On Mon, Oct 25, 2010 at 9:34 PM, Li Zefan <lizf@cn.fujitsu.com> wrot=
e:
>>> Chris Mason wrote:
>>>> On Mon, Oct 25, 2010 at 03:11:22PM +0800, Li Zefan wrote:
>>>>> Lzo is a much faster compression algorithm than gzib, so would al=
low
>>>>> more users to enable transparent compression, and some users can
>>>>> choose from compression ratio and compression speed.
>>>> This is also much smaller than I expected, really nice. =A0It look=
s like
>>>> older kernels won't properly deal (nicely give EIO) with lzo compr=
essed
>>>> files?
>>>>
>>>> We can add compatbits to deal with that if it is the case.
>>>>
>>> I forgot compatibility issue with older kernels..
>>>
>>> Though I didn't test older kernels, I don't think they can deal wit=
h lzo
>>> compressed files properly, at least not for inlined extents, in whi=
ch
>>> case I think btrfs will just show compressed data to the users.
>>>
>>> So yes, an incompat flag is needed.
>>
>> I've been testing this set of patches on a 2.6.36 kernel with the
>> latest btrfs-unstable patches, and I wanted to provide my positive
>> feedback.
>>
>> The lzo compression patches worked as expected, and I did not
>> encounter any stability problems in my testing (which mainly consist=
ed
>> of decompressing a root partition archive and doing some compiling
>> chores in a chroot environment on that drive).
>>
>> I did some crude benchmarking on decompressing an archived root
>> partition to an empty btrfs drive, and my results were similar to th=
e
>> results posted by Li Zefan in the original post. =A0The lzo compress=
ion
>> did not compress quite as well as zlib, but was much faster.
>>
>> I did some test mounting of a lzo-compressed partition with an older
>> non-lzo-patched kernel, and as expected, the contents of the files
>> were garbled. =A0But I did not encounter kernel oops or other issues
>> when trying to read the garbled files.
>>
>> I also wanted to confirm that my other zlib-compressed partitions di=
d
>> not encounter any issues when bouncing back and forth between a
>> lzo-patched kernel and older kernels. =A0As expected, I did not see =
any
>> issues in the partitions that had only been mounted with zlib
>> compression.
>>
>> You'll want an incompat flag as indicated in previous posts, but I
>> look forward to seeing lzo compression in the future.
>>
>
> Thanks for testing!
>
> I had been occupied by other things, so have been silent on this.
> Actually I've added the incompat flag, but haven't done userspace
> programs.
>
> I'm setting up a git tree, and will send out a pull request to
> Chris this week. (probabaly)
>
> And I think I can add your Tested-by in the whole patchset? Except
> for the ioctl change, which I guess you didn't test.
>
> We really need more review and test for btrfs patches, so what
> you've done is really appreciatated. :)
>

Glad to help.  Feel free to add "Tested-by Mitch Harder
<mitch.harder@sabayonlinux.org>"

Regarding the "ioctl change", I tested the five patches submitted to
the M/L on Oct. 25, 2010.  Some minor merging changes were required on
patch 2/5 for the enum containing the new lzo options in super.c (due
to some other recent modifications to that enum for space_cache
option).

So if there was an additional "ioctl change", I did not test it.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
