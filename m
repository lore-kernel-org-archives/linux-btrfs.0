Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38745 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbbEFRFW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 13:05:22 -0400
Received: by igbhj9 with SMTP id hj9so22480544igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 10:05:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSYbumV4-SPXRCxTzb0gXw6NaLYrNUCC79bz7eUNOiSPw@mail.gmail.com>
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>
	<5549CCD8.2010000@cn.fujitsu.com>
	<CAJCQCtT0ff8fVrMQ7rrgW1VFkiBL+f_upGOUZ7DY65N62jAsBQ@mail.gmail.com>
	<5549DF66.5090900@cn.fujitsu.com>
	<CAJCQCtSYbumV4-SPXRCxTzb0gXw6NaLYrNUCC79bz7eUNOiSPw@mail.gmail.com>
Date: Wed, 6 May 2015 11:05:20 -0600
Message-ID: <CAJCQCtRjWYgGJkKp0jOsb31cqjyh00K2tV-wbJqnSAYC3ekcMg@mail.gmail.com>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
From: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        anonymous_temp_mail@yahoo.co.jp
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok so now that my mea culpa is out of the way, I'm actually wondering
why non-root users can't do certain btrfs tasks when they're read-only
commands.

[chris@f22m ~]$ btrfs fi show
ERROR: could not open /dev/sda7   ##this is new it wasn't doing this last night
btrfs-progs v4.0
[chris@f22m ~]$ btrfs fi df /
Data, single: total=4.00GiB, used=3.57GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=1.01GiB, used=198.30MiB
GlobalReserve, single: total=80.00MiB, used=0.00B
[chris@f22m ~]$ btrfs fi usage /
WARNING: can't read detailed chunk info, RAID5/6 numbers will be
incorrect, run as root
WARNING: can't get filesystem info from ioctl(FS_INFO), run as root
ERROR: couldn't get space info on '/' - Operation not permitted


I think usage is more useful than df for users, and contains largely
the same information as df + show, so I think all three should be
non-root user usable.

---
Chris Murphy
