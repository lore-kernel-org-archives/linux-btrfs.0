Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i2.italiaonline.it ([212.48.25.198]:43041 "EHLO
	smtp-18.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751489AbaKQTM3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 14:12:29 -0500
Message-ID: <546A46A5.8030603@inwind.it>
Date: Mon, 17 Nov 2014 20:04:05 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
CC: bug-grub@gnu.org
Subject: Re: BTRFS messes up snapshot LV with origin
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za>
In-Reply-To: <54699CC7.1050909@swiftspirit.co.za>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-17 07:59, Brendan Hide wrote:
> 
> That leaves two aspects of this issue which I view as two separate bugs:
> a) Btrfs cannot gracefully handle separate filesystems that have the same UUID. At all.
> b) Grub appears to pick the wrong filesystem when presented with two filesystems with the same UUID.
> 
> I feel a) is a btrfs bug.
> I feel b) is a bug that is more about "ecosystem design" than grub being silly.

Regarding a)
IIRC, btrfs collects the filesystem information by UUID; if two 
filesystems have the same UUID (like the LVM-snapshot case), the
last filesystem discovered overwrite the first one.

The filesystem discovering is done in user-space; so it should be simple
to skip a filesystem on a LVM-snapshot.

Regarding b)
I am bit confused: if I understood correctly, the root filesystem was
picked from a LVM-snapshot, so grub-probe *correctly* reported that
the root device is the snapshot.
The problem was that during the boot filesystem discovering: first
scanned the *real* device, then the LVM-snapshot; the latter
overwrote the former so the system booted from the LVM-snapshot.

My conclusion is that we should improve the btrfs scan so:
- in udev rules, a partition that is a LVM snapshot by default 
should be not scanned by "btrfs dev scan"
- "btrfs dev scan", during the partition discovery should skip the 
lvm-snapshot.

BR
G.Baroncelli



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
