Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37189 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602Ab3BXAbV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 19:31:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U9PVA-0002vT-Js
	for linux-btrfs@vger.kernel.org; Sun, 24 Feb 2013 01:31:36 +0100
Received: from slice.seblu.net ([82.234.72.62])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 01:31:36 +0100
Received: from seblu by slice.seblu.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 01:31:36 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?U8OpYmFzdGllbiBMdXR0cmluZ2Vy?= <seblu@seblu.net>
Subject: Re: Is my btrfs filesystem definitely dead?
Date: Sun, 24 Feb 2013 01:30:49 +0100
Message-ID: <kgbmvm$9j0$1@ger.gmane.org>
References: <kgbgvv$qvr$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <kgbgvv$qvr$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23/02/2013 23:48, Sébastien Luttringer wrote:
> Hello, after a crash with linux 3.8.0, I'm unable to mount my btrfs root
> filesystem. I tried with a archlinux rescue cd with a linux 3.7.5, but I
> got the following errors:
> 
> ... 
> 
> Trying to mount the FS i got a OOPS.
> 
> Is there something I can do to fix my filesystem?
> 
I (with help) found a great page[1] explaining how to handle this case.

# btrfs-zero-log /dev/sdd2
extent buffer leak: start 73207808 len 4096
*** Error in `btrfs-zero-log': corrupted double-linked list:
0x0000000000ac5ff0 ***

I have the btrfs-image dump saved if a developer is interested.


[1]
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my_filesystem.2C_and_I_get_a_kernel_oops.21


-- 
Sébastien "Seblu" Luttringer
https://www.seblu.net
GPG: 0x2072D77A

