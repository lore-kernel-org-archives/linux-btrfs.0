Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34833 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbL1B1b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:27:31 -0500
Received: by mail-io0-f176.google.com with SMTP id q126so293657427iof.2
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 17:27:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451265688.6320.22.camel@scientia.net>
References: <1451187536.6446.14.camel@scientia.net>
	<pan$bcf44$1632328c$31564c06$c04774a8@cox.net>
	<1451265688.6320.22.camel@scientia.net>
Date: Sun, 27 Dec 2015 18:27:31 -0700
Message-ID: <CAJCQCtRGBUHefeK2H7-bNVBTZbgxbK6YDLsaiPxvKvZ7ixdXBQ@mail.gmail.com>
Subject: Re: [BUG?] btrfs scrub -d doesn't scan all devices
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 27, 2015 at 6:21 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Sun, 2015-12-27 at 07:22 +0000, Duncan wrote:
>> I'd call that NOTABUG.  As the btrfs-scrub manpage suggests:
>>
>> * When you point scrub at a mountpoint, it scrubs all devices
>> composing
>> that filesystem.
> Uhm,.. mine doesn't contain this,... neither do those of the master or
> devel branches from David's repo... or am I just blind?
>
> Actually it says:
>>DESCRIPTION
>>       btrfs scrub is used to scrub a btrfs filesystem, which will read all
>>       data from all disks and verify checksums.
>
> Also, if it would allow to only selectively scrub parts of the fs (e.g.
> just some devices or subpaths/subvols/files) than the whole syntax for
> cancel, break, etc. would become ambiguous.
>
>> Since /dev/disk/by-*/* are symlinks to various block-device nodes,
>> it
>> follows that if you point scrub at them, only the device pointed at
>> is
>> scrubbed, exactly as one might expect based on the manpage.
> Sure... that was clear... but I have another manpage than yours...
> perhaps some distro specific patch?

Fedora carries pretty much unmodified upstream btrfs-progs and I see
what both of you are seeing (I have 4.3.1).

The description does somewhat confusingly say "btrfs scrub is used to
scrub a btrfs filesystem, which will read all data from all disks and
verify checksums" but under subcommand > start it contains the
following qualification as the first sentence:

Start a scrub on all devices of the filesystem identified by <path> or
on a single <device>.



-- 
Chris Murphy
