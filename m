Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:44012 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3KLUEs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 15:04:48 -0500
Received: by mail-bk0-f49.google.com with SMTP id w14so2952129bkz.8
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 12:04:47 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <52828071.8090305@libero.it>
References: <1384263757-25627-1-git-send-email-fdmanana@gmail.com>
	<52828071.8090305@libero.it>
Date: Tue, 12 Nov 2013 20:04:47 +0000
Message-ID: <CAL3q7H7mF2sPT7+xR6ArbkdTnN1bWd4v6=woD9rDAZCtxf5aig@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add support for inode properties
From: Filipe David Manana <fdmanana@gmail.com>
To: kreijack@inwind.it
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 12, 2013 at 7:24 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hi Filipe,

Hi

>
> On 2013-11-12 14:42, Filipe David Borba Manana wrote:
>> This change adds infrastructure to allow for generic properties for
>> inodes via a new ioctl.
>
> I am sure that there is a valid reason, but I was not able to find it:
> why implement a new ioctl instead of using the *{set,get)xattr(2) syscall ?

Those require one of the following name prefixes: "user.",
"security.", "trusted." or "system.". Only "user." can be set from
user space and requires no special privileges/capabilities (if you
have the necessary permissions on the target inode).

It could be implemented via the "user." prefix, like
"user.btrfs.something" for example - but it can break user
applications if they use such prefix already, and we want to validate
the values set for such properties too.

>
> I noticed that you implemented the Compression properties set/get: is
> this from "chattr -c" ?

With chattr -c you can't specify the compression algorithm - it will
use the default (zlib) or the one you specified via mount options.

thanks

>
> [... cut other lines ... ]
>
> G.Baroncelli
>
> --
> gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
