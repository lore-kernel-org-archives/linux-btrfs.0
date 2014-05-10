Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52533 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751132AbaEJQtx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 12:49:53 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unable to mount filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAF6NbWy+0AqJS3GdewrQfO=z1NWhYOUBtOFy+B2DjTO5F3i6aQ@mail.gmail.com>
Date: Sat, 10 May 2014 10:49:07 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <230A0896-9CCD-4B48-A0D2-4BB5932BDEAB@colorremedies.com>
References: <CAF6NbWy+0AqJS3GdewrQfO=z1NWhYOUBtOFy+B2DjTO5F3i6aQ@mail.gmail.com>
To: Chris Korent <ckorent@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 8, 2014, at 7:06 AM, Chris Korent <ckorent@gmail.com> wrote:

> Linux sysresccd 3.10.35-std420-amd64 #2 SMP Wed Apr 2 18:31:51 UTC
> 
> btrfs --version
> Btrfs v3.14.1

I'm uncertain if this is an OK combination. I'm under the impression that the kernel should be the same or newer version than progs. Also kernel 3.10 is old in Btrfs terms. Before altering the file system further, I'd try a normal mount with the newest kernel you can get your hands on. If normal mount doesn't work, try either -o ro,recovery (bit more conservative but any repair isn't permanent) or -o recovery.

Although before you even get started, it's probably a good idea to take an image:

btrfs-image -c9 -t4 /dev/sdX /path/to/big/file

If you use btrfs check don't use any options yet.

The errors look a lot like Marc Merlin's error messages, and is also a case of Btrfs on dmcrypt.


Chris Murphy

