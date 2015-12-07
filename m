Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:46746
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbbLGLsE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 06:48:04 -0500
Subject: Re: [PATCH] btrfs: Enhance super validation check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
References: <1449477555-10333-1-git-send-email-quwenruo@cn.fujitsu.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <566571F0.2010002@googlemail.com>
Date: Mon, 7 Dec 2015 12:48:00 +0100
MIME-Version: 1.0
In-Reply-To: <1449477555-10333-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/07/15 09:39, Qu Wenruo wrote:
(..)
> +#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)

It looks like you diffed from a tree that has Josef's patch
called "Btrfs: add metadump_v2 support to the kernel" [1] applied,
which never made it upstream (probably got lost in the 4.0 mess).
This patch is not yet in 4.4rc, so merging your patch will introduce
half of Josef's patch but with the bits in inode.c missing.

cc:'ing Chris to make sure he applies that missing patch as well.

cheers,
Holger

[1] http://www.spinics.net/lists/linux-btrfs/msg41973.html

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlZlcewACgkQD4E0Cdjc7s2AjACeJKjfyJDRQBVM9y2j90MaZhjX
ynwAn0oKMM9MTZ4I8cmuxnHGgj3ZeSv4
=Jb6u
-----END PGP SIGNATURE-----
