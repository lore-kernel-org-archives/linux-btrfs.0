Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35041 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbJWPzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 11:55:35 -0400
Received: by igbkq10 with SMTP id kq10so19264318igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2015 08:55:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1445614907.16522.6.camel@tnxip.de>
References: <1445614907.16522.6.camel@tnxip.de>
Date: Fri, 23 Oct 2015 16:55:35 +0100
Message-ID: <CAL3q7H6=HwgJEi+yR428F-_ep1GuDXmV-0SJryLY2V-yidBaMw@mail.gmail.com>
Subject: Re: Linux 4.2.4 kernel panic while balancing
From: Filipe Manana <fdmanana@gmail.com>
To: maltesch@gmx.de
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 23, 2015 at 4:41 PM, Malte Schröder <malte@tnxip.de> wrote:
> Hi,
> kernel 4.2 crashes more or less reliably when running btrfs balance.
> The filesystem in question is running in RAID1 mode. This happens quite
> reliably.
> Btrfs filesystem check doesn't show any problems.
>
> Dmesg output is attached.
>
> I'll happily provide more information if needed.

Yeah, we're aware of the problem.

It's being fixed/debugged/discussed in the following (recent) thread:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/49517

That patch there should fix the problem if you aren't using qgroups.
If you're using qgroups, stay tuned and another fix for that case
should come soon.

thanks


>
> Regards
> Malte



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
