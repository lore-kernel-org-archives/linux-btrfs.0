Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35646 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563AbbLNV0X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 16:26:23 -0500
Received: by iofq126 with SMTP id q126so49155606iof.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 13:26:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <566EC2D7.3000101@gmail.com>
References: <20151204120529.37E47D5A28@emkei.cz>
	<20151204130758.GR8775@carfax.org.uk>
	<1449286104.18841.14.camel@scientia.net>
	<pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	<1449366680.3183.37.camel@scientia.net>
	<56644785.4090702@gmx.com>
	<1449639588.7835.2.camel@scientia.net>
	<5668A1CB.1020007@anonym.com>
	<CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
	<1449872498.31388.74.camel@fo>
	<CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
	<1450052868.30943.27.camel@scientia.net>
	<566EC2D7.3000101@gmail.com>
Date: Mon, 14 Dec 2015 14:26:22 -0700
Message-ID: <CAJCQCtTuETCh_n3dnhPbVBx6_0dcAmNgNWN_bpsTE8goH8byKg@mail.gmail.com>
Subject: Re: attacking btrfs filesystems via UUID collisions?
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 14, 2015 at 6:23 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> Agreed, if yo9u can't substantiate _why_ it's bad practice, then you aren't
> making a valid argument.  The fact that there is software that doesn't
> handle it well would say to me based on established practice that that
> software is what's broken, not common practice.

The automobile is invented and due to the ensuing chaos, common
practice of doing whatever the F you wanted came to an end in favor of
rules of the road and traffic lights. I'm sure some people went
ballistic, but for the most part things were much better without the
brokenness or prior common practice.

So the fact we're going to have this problem with all file systems
that incorporate the volume UUID into the metadata stream, tells me
that the very rudimentary common practice of using dd needs to go
away, in general practice. I've already said data recovery (including
forensics) and sticking drives away on a shelf could be reasonable.

> The assumption that a UUID is actually unique is an inherently flawed one,
> because it depends both on the method of generation guaranteeing it's unique
> (and none of the defined methods guarantee that), and a distinct absence of
> malicious intent.

http://www.ietf.org/rfc/rfc4122.txt
"A UUID is 128 bits long, and can guarantee uniqueness across space and time."

Also see security considerations in section 6.


> On that note, why exactly is it better to make the filesystem UUID such an
> integral part of the filesystem?  The other thing I'm reading out of this
> all, is that by writing a total of 64 bytes to a specific location in a
> single disk in a multi-device BTRFS filesystem, you can make the whole
> filesystem fall apart, which is absolutely absurd.


OK maybe I'm  missing something.

1. UUID is 128 bits. So where are you getting the additional 48 bytes from?
2. The volume UUID is in every superblock, which for all practical
purposes means at least two instances of that UUID per device.

Are you saying the file system falls apart when changing just one of
those volume UUIDs in one superblock? And how does it fall apart? I'd
say all volume UUID instances (each superblock, on every device)
should be checked and if any of them mismatch then fail to mount.

There could be some leveraging of the device WWN, or absent that its
serial number, propogated into all of the volume's devices (cross
referencing each other's devid to WWN or serial). And then that way
there's a way to differentiate. In the dd case, there would be
mismatching real device WWN/serial number and the one written in
metadata on all drives, including the copy. This doesn't say what
policy should happen next, just that at least it's known there's a
mismatch.


-- 
Chris Murphy
