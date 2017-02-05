Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:36697 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdBEARF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Feb 2017 19:17:05 -0500
Subject: Re: [RFC] python-btrfs: getting arch dependent ioctl handling right
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <be2d182a-6b8e-158f-6653-611c1d1896d7@mendix.com>
 <20170204235640.GB21899@carfax.org.uk>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <c2a46bda-c2f2-73c2-80e7-cb5cbc0ed824@mendix.com>
Date: Sun, 5 Feb 2017 01:17:03 +0100
MIME-Version: 1.0
In-Reply-To: <20170204235640.GB21899@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/05/2017 12:56 AM, Hugo Mills wrote:
> On Sun, Feb 05, 2017 at 12:37:18AM +0100, Hans van Kranenburg wrote:
>> Hi,
>>
>> since I'd like to have my python btrfs library work correctly for users
>> with other systems than amd64, I have been looking at IOCTL number
>> generation a bit.
>>
>> I just made something up in a branch, which follows the same way in
>> which the IOC defines in kernel source are done:
>>
>> https://github.com/knorrie/python-btrfs/commits/ioctl
>>
>> The only other hardware than amd64 I have is a raspberry pi, which
>> doesn't even seem to fall into the category having exceptions to the
>> defaults...
>>
>> So, my question is:
>>
>> 1. am I still doing it wrong, or is this going into the right direction?
>>
>> 2. can you please test this branch if you have access to any of 'alpha',
>> 'mips', 'powerpc', 'sparc', 'parisc' which runs a btrfs filesystem and
>> let me know if this makes it possible to use the library (e.g. run some
>> examples from the examples/ dir)
>>
>> 3. I also understand that there are difficulties for users who user 32
>> bit userland with a 64 bit kernel.
>>  - What is the exact technical reason for this?
> 
>    The usual problem with this configuration is that ioctl interfaces
> are defined in terms of a C struct. The ioctl number uses the size of
> the struct as part of its definition.
> 
>    The usual bug is that different bitnesses have different packing
> rules, so
> 
> struct foo {
>    u32 a;
>    u64 b;
> };
> 
> on 64-bit architectures is 16 bytes long. On 32-bit architectures,
> it's 12 bytes. Since the length is different, those result in
> different ioctl numbers in userspace and in the kernel, leading to
> ioctl not found.

Ok, so in my case it depends on the behaviour of the python struct
module. Since I use the resulting size to compute the ioctl number, it
should reliably go wrong if there's a problem.

E.g:

ioctl_fs_info_args = struct.Struct('=QQ16sLLL980x')
IOC_FS_INFO = _IOR(BTRFS_IOCTL_MAGIC, 31, ioctl_fs_info_args)

Well, except for things like this one, which makes sure it's always 4096:

ioctl_search_key = struct.Struct('=Q6QLLL4x32x')
ioctl_search_args = struct.Struct('{0}{1}x'.format(
    ioctl_search_key.format.decode(), 4096 - ioctl_search_key.size))

IOC_TREE_SEARCH = _IOWR(BTRFS_IOCTL_MAGIC, 17, ioctl_search_args)

I guess that the fastest way for this use case to find out is to just
set up a 64/32 mixed system myself and test, since I can do that with
hardware I already have, either here or at work.

>    Two approaches are available for dealing with this: either use the
> "packed" attribute to prevent member alignment, so all architectures
> have the same layout, or put in dummy members to ensure that
> everything is aligned the way that 64-bit systems would do it.

Or.. is the problem non-existent at all, since I use the '=' native byte
order, standard size in the struct definitions...?

https://docs.python.org/2/library/struct.html#struct-alignment
https://docs.python.org/2/library/struct.html#format-characters

>>  - What's the general opinion about this usecase? (needs to work, or,
>> "doctor, if I push here it hurts; well, don't push there"...)
> 
>    Definitely needs to work, but it's a rare use-case on most machines
> (e.g. x86, arm, which covers the vast majority of machines out
> there). sparc is the main one that I know of where a 64/32 system is
> common; possibly mips as well. You will also find people running 64/32
> systems on x86, but it's not normal.
> 
>    Hugo.
> 


-- 
Hans van Kranenburg
