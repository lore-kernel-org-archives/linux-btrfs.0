Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52623 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2JFJbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2012 05:31:44 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Help understanding btrfsck output...
Date: Sat, 6 Oct 2012 11:31:42 +0200
Cc: =?iso-8859-1?q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
References: <506EA718.9080604@petaramesh.org> (sfid-20121005_184508_100097_E50D6A19)
In-Reply-To: <506EA718.9080604@petaramesh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210061131.42896.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 5. Oktober 2012 schrieb Swâmi Petaramesh:
> Hi there,
> 
> I have a system on which btrfsck gives the following output... I don't
> understand the meaning of the reported errors, so any clue would be
> appreciated. Is this something I should worry about, or not ?
> 
> Would I be advised to try "--repair" ? (Last time I tried this one, it
> completely b0rked a filesystem, beyond repair, and my wife would kill
> me ifever I trash this one, for that's her machine, so please help !
> ;-))
> 
> root@PartedMagic:~# btrfsck /dev/sda6
> checking extents
> checking fs roots
> root 258 inode 772 errors 400
> root 258 inode 1025 errors 400

I dunno about those errors.

What you can always do:

1) Update your backup - you have a backup, don´t you? Use a file based 
backup via rsync -aAXHSP or so.

2) Try repairing the filesystem.

3) If it fails redo the filesystem from scratch by formatting it and 
replaying your backup.

Maybe someone else can help with the meaning of the errors.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
