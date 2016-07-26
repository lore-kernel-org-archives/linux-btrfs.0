Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sub3.mail.dreamhost.com ([69.163.253.7]:34065 "EHLO
	homiemail-a75.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbcGZBvD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 21:51:03 -0400
Subject: Re: Force recalculation of a data block checksum
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org>
 <CAJCQCtRHi=xJ-mP2yTg5c9sfGk+WKnjzRikT7Y-5he8s+3sSVw@mail.gmail.com>
 <6699a315-17f4-9298-fb6b-64358c497be0@exroot.org>
 <818f5843-20ad-2a9e-9b88-a16689739c80@gmail.com>
From: Tomasz Melcer <liori@exroot.org>
Message-ID: <2e73284c-797a-5322-3640-5bf65400c04f@exroot.org>
Date: Tue, 26 Jul 2016 03:50:58 +0200
MIME-Version: 1.0
In-Reply-To: <818f5843-20ad-2a9e-9b88-a16689739c80@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24.07.2016 07:07, Andrei Borzenkov wrote:
> Rewriting single block in question should do it. As you can read from
> raw device and have both physical and logical block address something like
>
> dd if=/dev/sdd1 skip=222940168 count=8 | dd of=/path/to/dysk/dysk.bin
> seek=189669768 conv=notrunc count=8

Thank you for the one-liner, I thought of doing it myself before, but 
when I tried to figure out which numbers mean what in scrub messages, I 
got a bit lost.

However, this one-liner doesn't seem to work here; `dd` prints:

#v+
8+0 records in
8+0 records out
4096 bytes (4.1 kB) copied, 5.2857e-05 s, 77.5 MB/s
dd: writing to ‘/media/liori/USB/dysk/dysk.bin’: Input/output error
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00364222 s, 0.0 kB/s
#v-


I'm not sure what would this message mean in this case. Is btrfs reading 
the block before writing? Maybe some block blacklist stored somewhere (I 
see that the corruption counter in scrub messages go up even if it 
reports the same errors in subsequent runs)?


> If you have possibility to verify file content(s), this technique can be
> used to read over unreadable parts of file by combining multiple dd's
> from file and device.

Some of the files stored in this `dysk/dysk.bin` disk image have some 
internal checksums (zip archives, etc.). That includes the ones hit by 
the checksum error. I'll try verifying these later.



-- 
Tomasz Melcer
