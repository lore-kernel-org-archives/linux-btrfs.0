Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34292 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3CPSTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:43 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How to recover uncorrectable errors ?
Date: Sat, 16 Mar 2013 19:19:41 +0100
Cc: =?utf-8?q?Fr=C3=A9d=C3=A9ric_COIFFIER?= <frederic.coiffier@free.fr>
References: <6033676.gK0GbPgrpE@athlonxp> (sfid-20130308_132012_518626_1D5201B4)
In-Reply-To: <6033676.gK0GbPgrpE@athlonxp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303161919.41734.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 8. März 2013 schrieb Frédéric COIFFIER:
> Today, I can't remove the file (and I can't delete its directory),
> updatedb runs during hours when it tries to read this file. So, what is
> the best way to recover these errors (as I think that some files are
> definitely lost) ? I would like to identify the corrupted files and to
> delete them.

Well, if nothing else works, you can still make a backup, diff it with an
older backup to possible recover the corrupted files or at least older
versions of it and redo the filesystem. After verify that the hardware
works okay :)

As said, these errors are called uncorrectable for a reason. When they
happen on file data it should be possible to delete the offending file,
but then AFAIK BTRFS also reports on which file they happen.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
