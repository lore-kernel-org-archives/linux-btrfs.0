Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:32918 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaC3NNh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Mar 2014 09:13:37 -0400
Received: by mail-la0-f53.google.com with SMTP id b8so5084425lan.12
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Mar 2014 06:13:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140330124224.GN7442@carfax.org.uk>
References: <20140322210455.GL28005@merlins.org>
	<20140330032202.GV22552@merlins.org>
	<20140330124224.GN7442@carfax.org.uk>
Date: Sun, 30 Mar 2014 14:13:35 +0100
Message-ID: <CAL3q7H6C+fBBK4n7cL8r1zoZ=onn2hM5jKLcxN4b5dbQnUKXcA@mail.gmail.com>
Subject: Re: btrfs send/receive still gets out of sync in 3.14.0
From: Filipe David Manana <fdmanana@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Marc MERLIN <marc@merlins.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 30, 2014 at 1:42 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Mar 29, 2014 at 08:22:02PM -0700, Marc MERLIN wrote:
>> On Sat, Mar 22, 2014 at 02:04:56PM -0700, Marc MERLIN wrote:
>> > After deleting a huge directory tree in my /home subvolume, syncing
>> > snapshots now fails with:
>> >
>> > ERROR: rmdir o1952777-157-0 failed. No such file or directory
>>
>> So, I'm ok again after I deleted my destination snapshot and re-init'ed,
>> but on multi terabyte backups, this ain't great :)
>>
>> Do I need to file a bug that btrfs send/receive still gets out of sync
>> in 3.14, or is it already known and maybe even fixed in btrfs-next?
>
>    Filipe has been posting a series of patches related to send/receive
> recently, so this may be related to those bugs.

Yes, this one in particular might have fixed the issue:

http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=29d6d30f5c8aa58b04f40a58442df3bcaae5a1d5

(There might be other cases that attempt to rmdir a non-existing
orphan directory)

>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>                    --- Gort!  Klaatu barada nikto! ---



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
