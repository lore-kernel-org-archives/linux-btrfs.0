Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35228 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbcGXFHx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 01:07:53 -0400
Received: by mail-lf0-f45.google.com with SMTP id f93so109191726lfi.2
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 22:07:52 -0700 (PDT)
Subject: Re: Force recalculation of a data block checksum
To: Tomasz Melcer <liori@exroot.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org>
 <CAJCQCtRHi=xJ-mP2yTg5c9sfGk+WKnjzRikT7Y-5he8s+3sSVw@mail.gmail.com>
 <6699a315-17f4-9298-fb6b-64358c497be0@exroot.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <818f5843-20ad-2a9e-9b88-a16689739c80@gmail.com>
Date: Sun, 24 Jul 2016 08:07:50 +0300
MIME-Version: 1.0
In-Reply-To: <6699a315-17f4-9298-fb6b-64358c497be0@exroot.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

24.07.2016 07:32, Tomasz Melcer пишет:
> On 24.07.2016 04:16, Chris Murphy wrote:
>> On Sat, Jul 23, 2016 at 8:03 PM, Tomasz Melcer <liori@exroot.org> wrote:
>>> How can I ask btrfs to recompute the checksum of a data block as it is
>>> stored on the drive?
>>
>> Since btrfs-progs 3.17 'btrfs check --init-csum-tree' will create a
>> whole new csum tree.
> 
> I can't make this command recalculate only checksum of that single file?
> 
> 

Rewriting single block in question should do it. As you can read from
raw device and have both physical and logical block address something like

dd if=/dev/sdd1 skip=222940168 count=8 | dd of=/path/to/dysk/dysk.bin
seek=189669768 conv=notrunc count=8

If you have possibility to verify file content(s), this technique can be
used to read over unreadable parts of file by combining multiple dd's
from file and device.

It probably makes sense to create (read-only) snapshot to make sure you
have old content available.
