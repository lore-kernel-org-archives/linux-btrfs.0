Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:52476 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbbI0TBG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 15:01:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22024.14700.482188.433115@localhost.localdomain>
Date: Sun, 27 Sep 2015 20:46:04 +0200
From: lutz.euler@freenet.de (Lutz Euler)
To: Chris West <solo-btrfs@goeswhere.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: fstrim silently does nothing on dev add/dev rem'd filesystem
In-Reply-To: <20150927175252.GA24990@blind.goeswhere.com>
References: <20150927175252.GA24990@blind.goeswhere.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

> I have a filesystem for which fstrim won't do anything.
> The filesystem has a history of abuse; dev add, dev remove, dding, ...
> 
> There's nothing wrong with the kernel or the disc; other btrfs volumes
> on the same disc trim fine, and the volume used to trim fine.
> 
> By "won't trim", I mean that it always, instantly returns 0 bytes
> trimmed:

you probably suffer from the same problem I had a few years ago.
It is a bug in how btrfs implements fstrim. Adding and removing devices
is the way I got my btrfs filesystem into the same situation then.

See for the background:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/15597

I wrote a patch, see here:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg40618.html

I understand that in kernel 4.3 there will be an extension so that
fstrim trims free space outside of allocated chunks. This is orthogonal;
my patch allows to trim free space inside allocated chunks (which,
somewhat accidentally, works for most btrfs filesystems since a long
time) even with filesystems like yours.

Kind regards,

Lutz Euler
