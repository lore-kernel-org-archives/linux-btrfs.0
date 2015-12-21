Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33720 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbbLUJ2i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 04:28:38 -0500
Received: by mail-io0-f174.google.com with SMTP id 186so150707520iow.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Dec 2015 01:28:37 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20151221081432.GR26782@carfax.org.uk>
References: <CAC=t97A1S6599aHWCCin7KnFWARs_ebfK6GptAXZQbFnSio7eA@mail.gmail.com>
	<20151221081432.GR26782@carfax.org.uk>
Date: Mon, 21 Dec 2015 09:28:37 +0000
Message-ID: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
Subject: Re: defrag vs autodefrag
From: Filipe Manana <fdmanana@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Donald Pearson <donaldwhpearson@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 21, 2015 at 8:14 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Dec 20, 2015 at 07:26:07PM -0600, Donald Pearson wrote:
>> I read an implication in a different thread that defrag and autodefrag
>> behave differently in that autodefrag is more snapshot friendly for
>> COW data.
>>
>> Did I understand that correctly?  I have not been doing defrag on my
>> virtual machine image directory because I do use a snapshot schedule
>> and the way I understood things, a defrag would basically decouple the
>> live data from the snapshots and greatly increase utilization.
>>
>> It sounded like autodefrag does not have this problem?
>
>    Correct.

Hum?
How is that so? Snapshot-aware defrag was disabled almost 2 years ago,
and that piece of code is used both by a "manual" defrag (ioctl) and
by automatic defrag.

>
>> If that's true, is there any case where it would not be best practice
>> to mount with autodefrag enabled?
>
>    When you are already tight on I/O bandwidth for your application.
> autodefrag increases the amount of I/O the disks do (because it's
> rewriting parts of the file near each write, as well as just the piece
> that's being written by userspace).
>
>    Hugo.
>
> --
> Hugo Mills             | UNIX: Japanese brand of food containers
> hugo@... carfax.org.uk |
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
