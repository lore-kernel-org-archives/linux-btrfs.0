Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:53190 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbaCQNIY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 09:08:24 -0400
Received: by mail-la0-f54.google.com with SMTP id mc6so3653781lab.13
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 06:08:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140317124708.GF21978@lupin>
References: <20140317055754.GA21978@lupin>
	<CAL3q7H6c5z7N6k0ixT+KN6+qfEzOMgrBOWQRX30vsfqSZoViTg@mail.gmail.com>
	<20140317124708.GF21978@lupin>
Date: Mon, 17 Mar 2014 13:08:22 +0000
Message-ID: <CAL3q7H7s7UHYn0smXYfOrn9p+s7nDsENK-2PH9iydHcgZ5_68Q@mail.gmail.com>
Subject: Re: BTRFS critical / kernel BUG / high load
From: Filipe David Manana <fdmanana@gmail.com>
To: Florian Bruhin <me@the-compiler.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 17, 2014 at 12:47 PM, Florian Bruhin <me@the-compiler.org> wrote:
> * Filipe David Manana <fdmanana@gmail.com> [2014-03-17 11:16:35 +0000]:
>> On Mon, Mar 17, 2014 at 5:57 AM, Florian Bruhin <me@the-compiler.org> wrote:
>> > Hi,
>> >
>> > on one of my servers running btrfs, I noticed a very high load of
>> > 26/26/26. After investigating further, this happened in my logs about
>> > 5 minutes before the monitoring alerted me because of the load:
>>
>> This issue was fixed in kernel 3.14 by:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5de865eebb8330eee19c37b31fb6f315a09d4273
>>
>> It was already backported to 3.12.14 but not yet to any 3.13 release.
>
> Thanks, I see.
>
> What about the free space error messages I got after the reboot?

It's a different problem. It sounds like it's what Miao fixed recently:

http://www.spinics.net/lists/linux-btrfs/msg30805.html


>
> Should I do anything or do I have to worry about anything being
> corrupt? I'm running a scrub right now.
>
> Florian
>
> --
> () ascii ribbon campaign - stop html mail    www.asciiribbon.org
> /\ www.the-compiler.org  | I love long mails http://email.is-not-s.ms/
> QOTD: "I haven't come far enough, and don't call me baby."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
