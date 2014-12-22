Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:33985 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaLVSnk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 13:43:40 -0500
Received: by mail-yh0-f49.google.com with SMTP id f10so2536046yha.22
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 10:43:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54985E4C.40003@gmail.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
	<54982A79.1090102@gmail.com>
	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>
	<54985E4C.40003@gmail.com>
Date: Mon, 22 Dec 2014 11:43:39 -0700
Message-ID: <CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
From: Chris Murphy <lists@colorremedies.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 11:09 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:

> Personally, I'd love to see unlimited length xattr's like NTFS and HFS+ do,
> as that would greatly improve interoperability (both Windows and OS X use
> xattrs, although they call them 'alternative data streams' and 'forks'
> respectively), and provide a higher likelihood that xattrs would start
> getting used more.

This is two years old, but it looks like NFS will not support xattr.
http://comments.gmane.org/gmane.linux.nfs/53259

It looks like SMB does support xattr (and sometimes requires it) but I
have no idea to what degree, including the host/client preservation on
different filesystems. [1] It would still be helpful for cp and rsync
to be able to preserve xattr, however Apple has moved to a new on-disk
format that makes the future of reading OS X volumes on Linux an open
question. [2]




[1]e.g. Btrfs > Samba- server > SMB over TCP > "Apple SMB2" > HFS+.
And then the OS X client pushing a file to the server is a separate
test. Next test would be OS X as server and Linux as client to do HFS+
> "Apple SMB2" > SMB over TCP > Samba-client > Btrfs, and then Linux
client pushing a file to OS X is a separate test. So it's four tests
for any combination of filesystems.

[2] Apple has a logical volume manager called CoreStorage. Until
recently it's mainly used to implement full disk (volume) encryption,
but encryption is actually optional. It's also used to combine SSD+HDD
partitions into a single logical volume using the SSD as a cache.
Starting with 10.10 "Yosemite" it's used by default for the main
HFSJ/X volume for system/apps/user data, and even legacy OS X only
installations are converted to a CoreStorage logical volume upon
upgrading. There's no pre-baked support on linux for this right now,
and I'm not really sure if/when we'd ever see this in a distribution
by default.
http://www.cl.cam.ac.uk/~osc22/docs/cl_fv2_presentation_2012.pdf
https://github.com/libyal/libfvde/


-- 
Chris Murphy
