Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44730 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbbFIRyf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jun 2015 13:54:35 -0400
Date: Tue, 9 Jun 2015 19:55:05 +0200
From: <pubny@xs4all.nl>
To: linux-btrfs@vger.kernel.org
Subject: "@" prefix in subvolume paths
Message-ID: <20150609195505.12ace1e8@host22323.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've noticed this "@" sign in the subvolume's path with SLES12. I'm
wondering what is its purpose. openSUSE 13.2 doesn't seem to be using
it.

Thanks,
Gábor


SLES12:
# btrfs sub list /
ID 257 gen 2270 top level 5 path @
ID 258 gen 1655 top level 257 path @/boot/grub2/i386-pc
ID 259 gen 4263 top level 257 path @/boot/grub2/x86_64-efi
ID 260 gen 4037 top level 257 path @/opt
ID 261 gen 2553 top level 257 path @/srv
ID 262 gen 4521 top level 257 path @/tmp
ID 263 gen 4492 top level 257 path @/usr/local
ID 264 gen 1655 top level 257 path @/var/crash
ID 265 gen 1655 top level 257 path @/var/lib/mailman
ID 266 gen 1655 top level 257 path @/var/lib/named
ID 267 gen 1655 top level 257 path @/var/lib/pgsql
ID 268 gen 4523 top level 257 path @/var/log
ID 269 gen 1655 top level 257 path @/var/opt
ID 270 gen 4524 top level 257 path @/var/spool
ID 271 gen 4521 top level 257 path @/var/tmp
ID 275 gen 4505 top level 257 path @/.snapshots


openSUSE 13.2:

# btrfs subvol list /
ID 257 gen 3481911 top level 5 path boot/grub2/i386-pc
ID 258 gen 3481911 top level 5 path boot/grub2/x86_64-efi
ID 259 gen 3517714 top level 5 path home
ID 260 gen 3515789 top level 5 path opt
ID 261 gen 3513493 top level 5 path srv
ID 262 gen 3513372 top level 5 path tmp
ID 263 gen 3517660 top level 5 path usr/local
ID 264 gen 3513372 top level 5 path var/crash
ID 265 gen 3513372 top level 5 path var/lib/mailman
ID 266 gen 3513372 top level 5 path var/lib/named
ID 267 gen 3513372 top level 5 path var/lib/pgsql
ID 268 gen 3517714 top level 5 path var/log
ID 269 gen 3513372 top level 5 path var/opt
ID 270 gen 3517714 top level 5 path var/spool
ID 271 gen 3517706 top level 5 path var/tmp
ID 276 gen 3517669 top level 5 path .snapshots
