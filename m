Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gourmet7.spamgourmet.com ([216.75.62.102]:53024 "EHLO
	gourmet8.spamgourmet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753894Ab3J2PTW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 11:19:22 -0400
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <btrfs.nrb@9ox.net>)
	id 1VbB4j-0006M7-RZ
	for linux-btrfs@vger.kernel.org; Tue, 29 Oct 2013 15:19:21 +0000
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 15:19:19 +0000
Message-ID: <CAOKNOqAv5yGNY3S77CO2w5Hk8wDZ2b9YTjSt_kc_-8TDkNnmKg@mail.gmail.com>
Subject: Moving over to use BTRFS - first time, needs encryption
From: btrfs.nrb@9ox.net
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,  I would be pleased to get some help after I have looked and not
figured out how this should work:

Summary
=======
btrfs device add <LUKS encrypted container> <path>
Returns - Inappropriate ioctl for device

Details
=====
// I have an existing btrfs file system

// built from one ~650G partition in middle of 1TB GPT disk,
// luksFormat 'ed
// mkfs.btrfs 'ed

// mounted and used successfully with:
# a=451609d5-89f5-4826-9052-ca60897d493e &&
b=ec3fb67c-41c2-4920-b67c-3d3b6451a1ee && c=ec3 && d=/data/nrb/
// myMount (a=LUKS UUID, b=BTRFS UUID, c=mount directory, d=mount path)
# sudo cryptsetup luksOpen /dev/disk/by-uuid/"${a}" "${a}" && mkdir -p
"$d$c" && sudo mount -U "$b" "$d$c" ; sudo blkid | grep $a ; sudo
blkid | grep $b ; sudo btrfs fi df "$d$c"
/dev/sdX5: UUID="451609d5-89f5-4826-9052-ca60897d493e" TYPE="crypto_LUKS"
/dev/mapper/451609d5-89f5-4826-9052-ca60897d493e:
UUID="ec3fb67c-41c2-4920-b67c-3d3b6451a1ee"
UUID_SUB="99ca8ddf-39d5-4c0d-b967-62aa6e76769d" TYPE="btrfs"

// Then to add a new encrypted device
// built from one 400G
// luksFormat 'ed
// no file system

# a=1965f0dc-c4df-43ec-8c13-56aebec5d886 && c=ec3 && d=/data/nrb/
// (a=LUKS UUID, c=existing mounted BTRFS filesystem directory, d=mount path)
# sudo cryptsetup luksOpen /dev/disk/by-uuid/"${a}" "${a}"
# btrfs device add /dev/disk/by-uuid/"${a}" "$d$c"
ERROR: error adding the device
'/dev/disk/by-uuid/1965f0dc-c4df-43ec-8c13-56aebec5d886' -
Inappropriate ioctl for device
// similar errors after trying /dev/dm-7 and /dev/sda2

# btrfs --version
Btrfs Btrfs v0.19
# uname -a
Linux 874-deb 3.2.0-4-amd64 #1 SMP Debian 3.2.51-1 x86_64 GNU/Linux

BR/ Nigel

