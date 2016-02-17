Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36540 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933706AbcBQORD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 09:17:03 -0500
Received: by mail-qg0-f43.google.com with SMTP id y9so12541062qgd.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 06:17:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6XnesHaU1COssFnvdnkxZwAD+isPLcYXxeip1b4UULug@mail.gmail.com>
References: <CAH4oapcJVfd74Wg64+4Q+xXzF07U1NKrQTnhoOA1ry2sJogkXQ@mail.gmail.com>
	<CAL3q7H6XnesHaU1COssFnvdnkxZwAD+isPLcYXxeip1b4UULug@mail.gmail.com>
Date: Wed, 17 Feb 2016 15:17:01 +0100
Message-ID: <CAH4oapf2FgYU8gybz+cd8hQBkcZsM0P6zuLoEhi2p+9yDc-xXA@mail.gmail.com>
Subject: Re: btrfs send error
From: Pavol Cupka <pavol.cupka@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Will do.
Thank you.


On Wed, Feb 17, 2016 at 3:01 PM, Filipe Manana <fdmanana@gmail.com> wrote:
> On Wed, Feb 17, 2016 at 1:02 PM, Pavol Cupka <pavol.cupka@gmail.com> wrote:
>> Hi all,
>>
>> when trying to btrfs send a snaphost I get this in dmesg:
>> [8614395.539466] BTRFS error (device sda1): did not find backref in
>> send_root. inode=673755, offset=131072, disk_byte=25730310144 found
>> extent=25730310144
>>
>> scrub reveals no errors
>> scrub status for bb8094e8-a7b1-4c2d-854e-77a9921e6f7e
>>         scrub started at Wed Feb 17 08:14:32 2016 and finished after 00:15:58
>>         total bytes scrubbed: 67.49GiB with 0 errors
>>
>> Is there something else that I might try to get this work?
>
> Just upgrade to a 4.3 or 4.4 kernel, or build a kernel with the patch below.
> The fix for this landed in 4.3:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d6589101b67a55107652050dfbf414403a93e351
>
>
>>
>> uname -a
>> Linux 4.1.7-hardened-r1 #4 SMP Mon Nov 9 20:02:04 CET 2015 x86_64
>> Intel(R) Atom(TM) CPU N2800 @ 1.86GHz GenuineIntel GNU/Linux
>>
>> btrfs --version
>> btrfs-progs v4.3.1
>>
>> Thanks Pavol
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
