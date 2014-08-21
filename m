Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:58346 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaHUSDF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 14:03:05 -0400
Message-ID: <53F635B9.6050900@libero.it>
Date: Thu, 21 Aug 2014 20:08:57 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs-progs: remove full /dev scanning
References: <53F51F4D.2090203@redhat.com>
In-Reply-To: <53F51F4D.2090203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/21/2014 12:21 AM, Eric Sandeen wrote:
> btrfs fileystem show and btrfs device scan today both have
> the "-d" option to scan everything under /dev.  But we also
> have a mechanism to scan everything in /proc/partitions, which
> should always be sufficient.
> 
> If anyone knows why we'd find something deep under /dev but
> not in /proc/partitions, speak now or forever hold your peace...

In the past I worked on this. From my commit messages [1]

[...]
the devices "scanned" are extracted from /proc/partitions. This
should avoid to scan devices not suitable for a btrfs filesystem like cdrom
and floppy or to scan not existant devices.
[...]

Of course I (we) don't care cdrom and/or floppy, but this raises 
the question: are there other block devices which aren't showed in 
proc/partitions ? 
I am thinking to some less common hardware like
NON USB sd disk (I saw this kind of hardware, but now I don't have 
it in my hands....).

GB

[1] 0dbd99fb3e117cd5f87eda492b6b4fab1b5bea23
> 
> Tested this by running through a matrix of -d, -m, or "" args
> for show/scan, for a 2-device fs, with and without a symlinked
> device, with and without a symlinked mountpoint.  All output was
> identical.
> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
