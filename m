Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:33289 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbbJSGE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 02:04:28 -0400
Received: by vkgy127 with SMTP id y127so1633537vkg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:04:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$6489f$54c8fba2$f1fc6c81$81eac@cox.net>
References: <56227910.7000208@gmail.com> <pan$6489f$54c8fba2$f1fc6c81$81eac@cox.net>
From: Paul Harvey <csirac2@gmail.com>
Date: Mon, 19 Oct 2015 17:04:08 +1100
Message-ID: <CAB3_QuKWHUMEfDZEnJL5+VSfNA96D-ziOXTgJOC1DKydBiD7_A@mail.gmail.com>
Subject: Re: btrfs autodefrag?
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 October 2015 at 16:46, Duncan <1i5t5.duncan@cox.net> wrote:
> Xavier Gnata posted on Sat, 17 Oct 2015 18:36:32 +0200 as excerpted:
>
>> Hi,
>>
>> On a desktop equipped with an ssd with one 100GB virtual image used
>> frequently, what do you recommend?
>> 1) nothing special, it is all fine as long as you have a recent kernel
>> (which I do)
>> 2) Disabling copy-on-write for just the VM image directory.
>> 3) autodefrag as a mount option.
>> 4) something else.
>>
>> I don't think this usecase is well documented therefore I asked this
>> question.

[snip]

> So ssd or spinning rust, there's serious conflicts between nocow and
> snapshotting that really must be taken into consideration if you're
> planning to both snapshot and nocow.

This is all spot on advice, but I just wanted to chime in to mention:
I've been experimenting with -
- Active working copy of VM image files are hosted on non-btrfs filesystems
- Regular scheduled rsync --inplace onto a btrfs subvol copy of the
file that *is* snapshotted and part of regular send/receive runs.

rsync --inplace does what it says on the tin: it just rewrites those
parts of a file which need to be updated. Thus it only gets written to
once prior to each snapshot run, rather than continuously.

So the theory is that I can retain CoW storage efficiency (hold lots
of snapshots cheaply) but still keep decent performance (by running
the active, in-use working copies outside of my normal snapshotted
btrfs filesystems).

The cost is obviously more filesystems than you'd normally have to
run, more complex disaster recovery, not to mention storage sizing has
to accommodate a working copy on a separate fs to the archived copies.
Plus, this rsync approach has noticeably bigger I/O overhead than
btrfs send/receive, although in my environment nobody is noticing.
