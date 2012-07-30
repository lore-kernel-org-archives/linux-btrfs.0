Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47170 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab2G3J4s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 05:56:48 -0400
Received: by lahd3 with SMTP id d3so3289440lah.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 02:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50165584.70707@arndnet.de>
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it>
 <20100124140837.5efcd526@simplux> <201001241415.47519.kreijack@inwind.it>
 <20100124142711.4afe8a81@simplux> <loom.20120729T205902-38@post.gmane.org>
 <CAGAVQTFADbS95X9NbtOBx7m=R3tXB1exauQtSpPfBc2m72tNqg@mail.gmail.com> <50165584.70707@arndnet.de>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Mon, 30 Jul 2012 04:56:27 -0500
Message-ID: <CAGAVQTH6DE1JFPWbX-VxLWWmQt1CYsFjFyKvAYKXY6aCSHgx5Q@mail.gmail.com>
Subject: Re: severe hardlink bug
To: Arnd Hannemann <arnd@arndnet.de>
Cc: Konstantin Dmitriev <ksee.zelgadis@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2012 at 4:36 AM, Arnd Hannemann <arnd@arndnet.de> wrote:
> Am 29.07.2012 21:13, schrieb C Anthony Risinger:
>> On Sun, Jul 29, 2012 at 2:02 PM, Konstantin Dmitriev
>> <ksee.zelgadis@gmail.com> wrote:
>>> Dipl.-Ing. Michael Niederle <mniederle <at> gmx.at> writes:
>>>
>>>> I reinstalled over 700 packages - plt-scheme beeing the only one failing due to
>>>> the btrfs link restriction.
>>>>
>>>
>>> I have hit the same issue - tried to run BackupPC with a pool on btrfs
>>> filesystem. After some time the error of "too many links (31)" appeared to me.
>>> Now I'm forced to migrate to some other filesystem...
>>
>> btrfs only fails when you have hundreds of hardlinks to the same file
>> in the *same* directory ... certainly not a standard use case.
>
> Actually, "hundreds of hardlinks" is certainly over optimistic.
> In my testing 15 links in the same directory were enough to get
> the "Too many links" error. It depends on the length of the file
> name of the hardlinks.

Yes, per the linked patch it states 4k as the limit ... I thought I
recalled a limit of 256 but it seems I may have been mistaken.

The purpose of my initial response was to suggest an alternative
strategy -- one complementing btrfs's strengths -- a simple rsync +
snapshot is much more effective than BackupPC IMO ... but then again,
I'm bias, because I generally think BackupPC is junk.

--

C Anthony
