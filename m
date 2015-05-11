Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54651 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbEKBl7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 May 2015 21:41:59 -0400
From: Russell Coker <russell@coker.com.au>
To: Philip Seeger <p0h0i0l0i0p@gmail.com>
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to dev stats
Date: Mon, 11 May 2015 11:41:54 +1000
Cc: linux-btrfs@vger.kernel.org
References: <554F6D43.2060806@googlemail.com> <CABR0jERqzkdTJxX_1S5WEZHDzX8=O8P7r+Bk0mesPLsR2n=w8A@mail.gmail.com> <554F963D.2040209@googlemail.com>
In-Reply-To: <554F963D.2040209@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201505111141.54771.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 11 May 2015 03:32:45 AM Philip Seeger wrote:
> However, it seems strange to me that a bunch of files is corrupted 
> simply because btrfs-progs is older than the kernel.

That won't happen.

> To trigger more csum errors, I ran a script that basically finds all 
> files and runs cat $file >/dev/null. I also scrubbed the filesystem.
> It's getting worse. The number of corrupted files has grown to 79 - all 
> in /home. Some of these files have not been modified in 3 years. I have 

Sounds like you are having errors in your RAM, CPU, motherboard, or hard drive 
cabling.  Turn the machine off ASAP and plug the disks into a different system, 
if you keep it running you will make it worse.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
