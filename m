Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35805 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbbGLUfc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jul 2015 16:35:32 -0400
Received: by lblf12 with SMTP id f12so45050708lbl.2
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2015 13:35:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <11405054.0T05W1bXEO@merkaba>
References: <CAPQXdDRKpp43M+by8wMGiMZa9VPD5XKs8CGpNLT=J41Q96E1Ug@mail.gmail.com>
	<3753681.2HYhjf7Zfa@merkaba>
	<CAPQXdDTT5E3f3VqAuQYKp3FwHjU45CfGW35du3HxRCHdyuz5gA@mail.gmail.com>
	<11405054.0T05W1bXEO@merkaba>
Date: Sun, 12 Jul 2015 14:35:30 -0600
Message-ID: <CAPQXdDT=T29uGvbWo6CXTuj-chDBAcr2ii5GCdhfrz35R-mEsQ@mail.gmail.com>
Subject: Re: Defrag operations sometimes don't work.
From: "erpo41@gmail.com" <erpo41@gmail.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 12, 2015 at 2:54 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Note however: Even without "sync" BTRFS will defragment the file. It may
> just take a while till the new extents are written. So there is no need to
> call "sync" after btrfs fi defrag.

My purpose in calling sync in that transcript was to ensure each
invocation of filefrag returned the correct results.

> Why are you trying to defragment anyway? What are you trying to achieve /
> solve?

There are several reasons. Some are technical and some are emotional.

Technical reason 1: I sometimes play computer games that are delivered
through Steam. If you're not familiar with it, Steam is a sort of
online storefront application for Linux and other platforms that--I
believe--delivers game patches by overwriting selected ranges in each
game's files. Lots of small overwrites are the main culprit behind
small files with thousand or tens of thousands of fragments on btrfs.
All I know for sure is that some game files have become heavily
fragmented and load times seem excessive, especially given that
they're older games compared to my hardware.

Technical reason 2: Whenever a new Ubuntu release comes out, I make
sure to download and burn the ISO before I upgrade my OS. Usually I
download the ISO using bittorrent, which uses lots of random writes
creating heavily fragmented downloads that severely impact read speeds
from my non-SSD hard disk. This increases my load quite a bit when I
seed the download back to other people. I've solved this problem in
the past by pausing the bittorrent client, copying the file to another
location, deleting the original, moving the copy back into place with
the same name, and resuming the client, but that's a pain. I'd rather
defragment instead.

Emotional reason 1: Heavily fragmented files on rotating media just
feel slovenly to me, like a person wearing dirty clothes or a bathroom
that hasn't been cleaned in a while.

Emotional reason 2: I switched from Windows to Linux in the late 90s.
At that time, RAM was expensive, so I often found myself in situations
where my kernel was dropping pages from the filesystem cache to make
room for application memory. Rereading those files later was very slow
if they were fragmented, so I religiously defragmented my Windows 95
and 98 machines every week. When I switched to Linux, I was dismayed
to learn that ext2 had no defragmentation tool, and I was very
skeptical of claims that "Linux doesn't need defragmentation",
especially considering that most of the people making those claims
probably had no idea how fragmented their own filesystems were. In the
years that followed, I was continually disappointed as stable
defragmentation tools did not appear for ext2 or any other popular
Linux filesystems, so I'm relieved and excited not to be in that
predicament anymore.

>> I'm now seeing that recursive defragging doesn't work the way I expect.
>> Running
>>
>> $ btrfs fi defrag -r /path/to
>>
>> returns almost immediately and does not reduce the number of fragments
>> in /path/to/file. However, running
>>
>> $ btrfs fi defrag /path/to/file
>>
>> does reduce the number of fragments.
>
> Well, I have no idea about this one. I have the same behavior with
>
>> >> btrfs --version: Btrfs v3.17
>
> v4.0

Thanks for checking,
Eric
