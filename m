Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60266 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3JZJaT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 05:30:19 -0400
Received: by mail-qa0-f44.google.com with SMTP id cm18so1118155qab.17
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 02:30:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131025104414.GD31029@carfax.org.uk>
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
	<CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
	<20131025163546.4cf3291a@natsu>
	<20131025104414.GD31029@carfax.org.uk>
Date: Sat, 26 Oct 2013 10:30:18 +0100
Message-ID: <CAOTdububnKzatt1ojXhXry36vkr1D3DgBc-HFks46=P6R40gmg@mail.gmail.com>
Subject: Re: swapfile on btrfs, temporary solution for wiki
From: "karim.allah.ahmed@gmail.com" <karim.allah.ahmed@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.net>,
        Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is the swap over NFS code upstream ?

On 10/25/13, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Oct 25, 2013 at 04:35:46PM +0600, Roman Mamedov wrote:
>> On Thu, 24 Oct 2013 23:52:01 +0300
>> Timofey Titovets <nefelim4ag@gmail.com> wrote:
>>
>> > Hello, i suggest temporary solution to use swap file under btrfs.
>> > I test it, and it work good.
>> >
>> > I invent simple the way, how create and using swap file, just see
>> > following sh code:
>> >
>> > swapfile=$(losetup -f) #free loop device
>> > truncate -s 8G /swap   #create 8G sparse swap file
>> > losetup $swapfile /swap #mount file to loop
>> > mkswap  $swapfile
>> > swapon  $swapfile
>> >
>> > i just adding this to rc.local and this work good.
>> > May be, add it to btrfs Wiki as temporary solution to using swap file?
>>
>> I always thought Btrfs does not allow swap files on purpose, because it is
>> not
>> deadlock-proof when used in the swapping context.
>
>    It's more that the current swap interface is based on device+block
> list, and if you balance a filesystem, the blocks for a file move --
> but there's no way of telling the swap code to cope with that.
>
>> Imagine you try swapping out pages to free up some memory, and in the
>> process
>> Btrfs needs to allocate some memory to actually perform the write, the
>> kernel
>> says "Sure, but for that we need to swap out some more pages..." You see
>> where
>> that goes.
>>
>> Same issue is possible with swap on other complex filesystems an example
>> being networked ones like NFS and SMB/CIFS.
>
>    The network filesystems have a similar problem as btrfs -- they
> don't export devices, and you don't get direct access to the low-level
> blocks under the FS, so the swap code can't deal with it.
>
>    That said, there's been a lot of work recently on getting
> swap-over-NFS to work properly -- effectively giving a new interface
> for the swap code that doesn't rely on direct mapping to device
> blocks. That new interface gives us the minimal external
> infrastructure necessary to consider doing swapfiles on btrfs.
>
>> It might work for some time (or even work 99% of time), but you still may
>> be
>> endangering your system to a possibility of a lock-up, and certainly
>> adding
>> that to any Wiki/FAQ/website as "the solution" might not be the best
>> choice.
>
>    The deadlock situation is dealt with by adding a flag to the memory
> allocator in the swap-critical paths, which says you're not allowed to
> swap anything when you make the allocation. That at least allows the
> memory allocation to fail (hopefully gracefully) without deadlocking.
> I suspect that this is also part of the swap-on-NFS work -- adding
> that flag everywhere necessary.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>        --- He's playing Schubert.  I think Schubert is losing. ---
>


-- 
Karim Allah Ahmed.
LinkedIn <http://eg.linkedin.com/pub/karim-allah-ahmed/13/829/550/>
