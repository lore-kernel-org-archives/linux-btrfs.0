Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35099 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbcBDMEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 07:04:36 -0500
Received: by mail-ig0-f174.google.com with SMTP id hb3so33305253igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 04:04:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1724218.nF6PTv1Cei@merkaba>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
	<56B2AA51.80908@cn.fujitsu.com>
	<CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
	<1724218.nF6PTv1Cei@merkaba>
Date: Thu, 4 Feb 2016 13:04:35 +0100
Message-ID: <CAM=f9=XYdeLDUUMgnCOGePJSaV3yh4Zi8CpjoPo33yqQU=8xZg@mail.gmail.com>
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
From: Moviuro <moviuro@gmail.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 4, 2016 at 11:14 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Am Donnerstag, 4. Februar 2016, 09:57:54 CET schrieb Moviuro:
>> > Although personally I like to let all the backward compatibility
>> > things go hell, but that's definitely not how things work. :(
>> >
>> > 2) End-user taste.
>> > Some end-users like such info as feedback of success.
>> > Of course other users like it act as silent as possible.
>>
>> I'm pretty sure that's... not the case. Almost everything on GNU/Linux
>> is silent. cd(1) is silent, cp(1) is silent, rm(1)...
>> What they all have though is a -v|--verbose switch.
>
> The various mkfs commands are not. Not one of them I know of. Additionally
> each one gives a different output.
>
> pvcreate, vgcreate, lvcreate and as well as the remove commands and probably
> other LVM commands are not (no one could argue, that from their ideas they
> come from HP/UX, but thats a Unix as well):
>
> merkaba:~> lvcreate -L 1G -n bla sata
>   Logical volume "bla" created.
>
> And I think, not testing right now, that also mdadm is not silent on creating
> a softraid.
>
> So while I agree with you that regular shell commands (coreutils, util-linux)
> are silent on success usually this does not appear to be the case with storage
> related commands in GNU/Linux.
To be perfectly honnest, my inspiration comes from zfs(8) on FreeBSD.
I'm pretty sure there is some inspiration we can find in its behavior.
(see https://www.freebsd.org/cgi/man.cgi?zfs(8) )
The output has both a human-readable form (using column(1)) and a
machine-parseable form (e.g. zfs get -o value used /zroot).
The output is limited to what is truly useful, etc.
I have not had any previous experience with any other FS or softraid
solutions, so I'm not familiar with those commands you gave, Martin.

Also, making silence a default option helps spare some typing:
>/dev/null : 11 char (force silence)
-v : 3 char (force verbose) (it's also far more readable)

I should start working on said guidelines.md later today or this weekend.

> I don´t have a clear oppinion about it other than I´d like to see some
> standard too. coreutils / util-linux both them to have some kind of standard,
> although not necessarily the same standard I bet. And I am not sure whether it
> is documented somewhere.
