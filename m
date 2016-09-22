Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:44863 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932978AbcIVKKO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 06:10:14 -0400
Subject: Re: Status of free-space-tree feature
To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, osandov@fb.com
References: <20160921092406.GD16983@twin.jikos.cz>
 <57E2602C.7050703@applied-asynchrony.com>
 <85fb7ee0-7f6a-e8a0-46c6-dac12c3e69d2@gmail.com>
 <20160921203152.GA7694@vader.DHCP.thefacebook.com>
 <20160922085205.GM16983@suse.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <058a4346-16f5-850e-2974-d783a132547b@mendix.com>
Date: Thu, 22 Sep 2016 12:10:09 +0200
MIME-Version: 1.0
In-Reply-To: <20160922085205.GM16983@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 09/22/2016 10:52 AM, David Sterba wrote:
> On Wed, Sep 21, 2016 at 01:31:52PM -0700, Omar Sandoval wrote:
>>>> I'm not sure I understand - can you explain why this is was so wrong?
>>>> Or Omar maybe?
>>>>
>>>> If btrfsck wants to correct something (write), it can simply always
>>>> and unconditionally invalidate the fst instead of trying to "repair"
>>>> it..and I think that's what happens at the moment (at least I think
>>>> it did for me recently). That seems like a safe and simple way.
>>> I know this is what it does with the regular FSC, but I'm not sure if it
>>> does so with the FST.  If it doesn't, it probably should though.
>>
>> It doesn't. The free space cache is easy to invalidate because we can
>> just compare the generation number of the superblock to that of the
>> space cache, but as it exists now, the free space tree doesn't have
>> anything equivalent. That means that any modifications that btrfs-progs
>> made to a space_cache=v2 filesystem could potentially have caused
>> filesystem corruption :/

Can you elaborate on what kind of corruption (characteristics / impact)
is meant here? Is it e.g. corruption as in a. filesystem becomes
unusable beyond repair b. kernel crashes when it encounters some data c.
data loss because disk space gets used twice, d. etc?

I suspect by not being able to update the free space info, but at the
same time doing writes, it results in free space being tracked which is
not actually free any more. I might assume (but haven't been reading /
searching through source code yet this morning) that a sane way of
dealing with a free space cache in kernel would be to always first
validate any claims about free space before actually trying to blindly
putting something in the advertised free range.

>> However, I talked this through with Chris, and he came up with a great
>> idea that will help us deal with both this issue and the endianness
>> issue [1] in one fell swoop. Basically, my objection to adding a compat
>> bit for the endianness bug was that it would unnecessarily affect the
>> vast majority of users on x86; forcing those users to recreate their
>> free space tree seemed silly. However, because of the btrfs-progs bug,
>> just to be safe, we might as well force everyone to recreate their free
>> space tree.
>>
>> The solution is to add a FREE_SPACE_TREE_VALID compat_ro bit. If the bit
>> isn't set, then we destroy and rebuild the free space tree. This covers
>> the case of big-endian kernels which created broken free space trees and
>> filesystems which could have possibly gone through btrfs-progs.

Just some humble feedback... what does "FREE_SPACE_TREE_VALID" mean in
two years from now, when another bug is found that might require the
same sledgehammer approach to fix it? Will it require adding
FREE_SPACE_TREE_NOW_REALLY_VALID?

Also, the same bit is being used for two different purposes...
 1. "pfew, we're hopefully post the btrfs-progs issue, and the user will
hopefully not use an old progs again that doesn't clear me when writing,
otherwise there's still no way to detect that and we'll falsely assume
we're ok, brrrr" (once)
 2. btrfs-progs without r/w fst but with fst invalidate support touched
the fs, (any time in the future)

btrfs progs >= 4.5 && < v4.7.3 are already "out in the wild". So I think
there should be a warning for users which want to try out FST. The
general recommendation to use btrfs-progs with a version number that is
at least as high as the kernel version (>=4.5 for FST) doesn't help any
more in this case.

Added it:
https://btrfs.wiki.kernel.org/index.php/Status#Free_space_tree

Still requires users to find and read this info instead of looking at
kernel release notes and man pages (so, it's great that it can be found
now, thanks to the status page).

>> This time we'll make sure not to make btrfs-progs think it can mount
>> FREE_SPACE_TREE_VALID filesystems read-write. We can even have
>> btrfs-progs check for that bit and clear it if it's mounting read-write.
>> The next time it gets mounted, the kernel will recreate the tree. It's
>> not pretty, but it'll work.
> 
> Sounds like a good plan to me. The bit is a form of 'clear_cache' mount.
> We need to to a coordinated fix (kernel, progs), if the patches are
> ready soon, 4.9 is feasible target.

How will this be announced, to prevent me from being unexpectedly
greeted with hours of filesystem downtime during mount?

What should be the way of working now, for a user which wants to use FST
and any btrfs-progs r/w functionality?

1) umount
2) mount with clear_cache,space_cache=v1
3) use progs, e.g. btrfstune
4) mount with clear_cache,space_cache=v2

Since users who benefit from the FST are generally users that run huge
filesystems, this gets a bit painful. But, I guess that might be the
price that you have to pay for using cool new things.

P.S. I really like the space tree, it's so much of an improvement on
btrfs-transaction commits!

-- 
Hans van Kranenburg
