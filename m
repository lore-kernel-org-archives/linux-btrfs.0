Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39961 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3KMAan (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 19:30:43 -0500
Received: by mail-bk0-f53.google.com with SMTP id na10so18657bkb.26
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 16:30:42 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131112200727.GG4315@carfax.org.uk>
References: <1384263757-25627-1-git-send-email-fdmanana@gmail.com>
	<52828071.8090305@libero.it>
	<CAL3q7H7mF2sPT7+xR6ArbkdTnN1bWd4v6=woD9rDAZCtxf5aig@mail.gmail.com>
	<20131112200727.GG4315@carfax.org.uk>
Date: Wed, 13 Nov 2013 00:30:41 +0000
Message-ID: <CAL3q7H74UOsFBbgHOSKt8N17WVFcK4VTQ1eEZ3Q8ryry+FRjuQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add support for inode properties
From: Filipe David Manana <fdmanana@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Filipe David Manana <fdmanana@gmail.com>,
        kreijack@inwind.it,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 12, 2013 at 8:07 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Nov 12, 2013 at 08:04:47PM +0000, Filipe David Manana wrote:
>> On Tue, Nov 12, 2013 at 7:24 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>> > Hi Filipe,
>>
>> Hi
>>
>> >
>> > On 2013-11-12 14:42, Filipe David Borba Manana wrote:
>> >> This change adds infrastructure to allow for generic properties for
>> >> inodes via a new ioctl.
>> >
>> > I am sure that there is a valid reason, but I was not able to find it:
>> > why implement a new ioctl instead of using the *{set,get)xattr(2) syscall ?
>>
>> Those require one of the following name prefixes: "user.",
>> "security.", "trusted." or "system.". Only "user." can be set from
>> user space and requires no special privileges/capabilities (if you
>> have the necessary permissions on the target inode).
>
>    Why only that limited set? Is that limited by POSIX, or executive
> fiat? Is there any likelihood of us getting an additional namespace?
> (fs.* maybe?)

Good question Hugo.

I have the understanding there's no issue using a new namespace,
perhaps it's not true.
What leads me to think this is that in fact there's one fs which uses
its own custom prefix, hfsplus:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/xattr.h?id=refs/tags/v3.12#n20

And it uses it in fs/hfsplus/xattr.c. I'm now realizing we probably
can use directly the regular setxattr and getxattr code paths in
fs/btrfs/xattr.c and avoid the new ioctls, simplifying things. Will
give it a try.

The vfs path for setting and getting xattrs also doesn't block us from
using xattrs with a new prefix (doesn't use the hfsplus "osx." prefix
constant anywhere).

thanks

>
>    Hugo.
>
>> It could be implemented via the "user." prefix, like
>> "user.btrfs.something" for example - but it can break user
>> applications if they use such prefix already, and we want to validate
>> the values set for such properties too.
>>
>> >
>> > I noticed that you implemented the Compression properties set/get: is
>> > this from "chattr -c" ?
>>
>> With chattr -c you can't specify the compression algorithm - it will
>> use the default (zlib) or the one you specified via mount options.
>>
>> thanks
>>
>> >
>> > [... cut other lines ... ]
>> >
>> > G.Baroncelli
>> >
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>     --- I write in C because using pointer arithmetic lets people ---
>                know that you're virile. -- Matthew Garrett



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
