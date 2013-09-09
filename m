Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab3IIVNw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 17:13:52 -0400
Message-ID: <522E3A0E.6080504@redhat.com>
Date: Mon, 09 Sep 2013 14:13:50 -0700
From: Andy Grover <agrover@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Chris Mason <chris.mason@fusionio.com>
Subject: btrfs.h and btrfs-progs licensing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

I'd like it to be possible to have a library that configures btrfs 
directly instead of using the cmdline tools. (I think Mark Fasheh and 
David Sterba have already done some work here.)

However, as it stands, the kernel's include/uapi/linux/btrfs.h and 
btrfs-progs are GPLv2, which means that a "libbtrfs" that is based on 
either of these might also be construed to need to be GPLv2, and any 
program *using* libbtrfs might also be construed to need to be GPLv2.

I don't think this was the intent.

I think we'd be better off if we relicense btrfs-progs to LGPLv2, and 
dual-license the kernel btrfs.h header to GPLv2/LGPLv2 (this may not be 
strictly necessary, RMS says it isn't[1], but we probably want to be 
completely clear).

This will involve getting the OK from everyone who has contributed to 
btrfs-progs. Yay git. If someone more closely involved with btrfs dev 
wanted to spearhead this I'd love it, but am willing to do it too (I 
*really* want a libbtrfs. :-)

Any thoughts? Objections?

Regards -- Andy

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0301.1/0362.html
