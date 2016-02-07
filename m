Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:32904 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbcBGX57 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Feb 2016 18:57:59 -0500
Received: by mail-ig0-f175.google.com with SMTP id y8so20224788igp.0
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Feb 2016 15:57:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B69286.3080205@gmail.com>
References: <56B66704.5070505@gmail.com>
	<CAJCQCtSOv8rhDi69NyR6J4cs91bc9ahh7382+kHz1knAe5BRdg@mail.gmail.com>
	<56B69286.3080205@gmail.com>
Date: Sun, 7 Feb 2016 16:57:58 -0700
Message-ID: <CAJCQCtQY8m9EMXxg40+9F9mbPiaunbgHDcztq_HrNCy1vpJ2Fw@mail.gmail.com>
Subject: Re: Unrecoverable error on raid10
From: Chris Murphy <lists@colorremedies.com>
To: Tom Arild Naess <tanaess@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 6, 2016 at 5:40 PM, Tom Arild Naess <tanaess@gmail.com> wrote:

>>> This is not what I expect from a raid10!
>>
>> Technically what you don't expect from raid10 is any notification that
>> the file may be corrupt at all. It'd be interesting to extract the
>> file with restore, and then compare hashes to a known good copy.
>
> Well, I really don't expect this to be happening at all. If this is a bug in
> btrfs, it could just as well have struck the same file on the server.

Seems like a bug in that the results are definitely not expected. But
there isn't enough information to isolate the source. I'm not aware of
any sort of Btrfs bug like this.


>This being a 16GB edited family film video file, I had the
> original source deleted, so I could very well end up with some very annoying
> chop in the video in a worst case scenario.
>
> Anyway, I just hope that if there is a bug in the code, this could help find
> it.

There isn't enough information to know what's even going on in this
particular instance, let alone to deduce if there's a bug in the code.
The entire dmesg would be more helpful than just one snippet, because
invariably the problem occurred before the uncorrectable corruption
messages appear. Whether or not the kernel messages report the
instigator is another question, it may have happened this boot, or
some other boot you no longer even have messages for.



Chris Murphy
