Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:60683 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaKBOWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Nov 2014 09:22:09 -0500
Received: by mail-la0-f44.google.com with SMTP id gf13so8329828lab.31
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Nov 2014 06:22:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20141102104952.GN907@carfax.org.uk>
References: <1798985.8i0FJtRps5@zafu>
	<20141102104952.GN907@carfax.org.uk>
Date: Sun, 2 Nov 2014 14:22:07 +0000
Message-ID: <CAL3q7H4iKLip_6KE19eLm2nAoLH05k8Ed=sTivLYr_VVy2=M5w@mail.gmail.com>
Subject: Re: Kernel 3.17.2 and RO snapshots
From: Filipe David Manana <fdmanana@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 2, 2014 at 10:49 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Nov 02, 2014 at 11:42:58AM +0100, Swâmi Petaramesh wrote:
>> Hi there,
>>
>> I'm a little lost with latest kernel issues, and would like to know if the
>> "data corruption" with RO snapshots is fixed in 3.17.2, or not yet ?
>
>    Yes, it is.
>
>> Also about this issuse, I'd like to know if :
>>
>> - Data corruption occurs when creating RO snapshots,
>
>    Yes.

More specifically, you won't lose your data or get it modified in some way.
The problem was that when a ro snapshot was created under specific
timings, the fs metadata on disk would never end up pointing to the
current (most recent) root of the snapshot. And this caused all sorts
of errors when accessing the snapshot after a umount + mount / reboot.

Code to fix the issue (correct the metadata to point to the correct
roots) went into btrfs' check command (btrfs-progs v3.17).

>
>> - Or if it can occur with just using a FS that already has RO snapshots ?
>
>    No.
>
>> - Or if it can occur when deleting existing RO snapshots with 3.17 ?
>
>    Not that I'm aware of.
>
>> Which means : If I have mistakenty upgraded to 3.17.2 a system containing RO
>> snapshots and cannot downgrade (big distro and drivers mess...), what is the
>> safest way to go ?
>
>    Leave it as it is. :)
>
>> And if data corruption occurs, should I expect it to affect snapshots only, or
>> the whole system ?
>
>    I _think_ it only affects the snapshots, but could bring the system
> down if you access the broken data. But you're safe with 3.17.2, so
> it's a moot point for you right now.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>       --- If it's December 1941 in Casablanca,  what time is it ---
>                               in New York?



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
