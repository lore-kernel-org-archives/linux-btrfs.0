Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:43785 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2HMRWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Aug 2012 13:22:13 -0400
Received: from 67.155.79.188.dynamic.jazztel.es ([188.79.155.67] helo=mail.viric.name)
	by mho-01-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1T0yLC-000Dim-7w
	for linux-btrfs@vger.kernel.org; Mon, 13 Aug 2012 17:22:10 +0000
Date: Mon, 13 Aug 2012 19:22:05 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: linux-btrfs@vger.kernel.org
Subject: Defragmenting directories, compression
Message-ID: <20120813172205.GE25996@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've run "btrfs fi defrag /nix", a directory with only three subdirectories.

One of them, "/nix/store" has lots of contents. I expected the operation to last
very short, because I thought it was not recursive. But for what I see in
btrfs_root_defrag, it looks like it's recursive. And it takes long.

Additionally, defragmenting on a directory ignores the '-clzo' kind of
compression settings. And I wonder... as it works recursively, will it
*uncompress* all that big amount of data I have there in lots of files? All that
data has been filled with a "compress=lzo" mount option from long ago.

Additionally, 'btrfs fi defrag <directory>' seems to require root permisions,
while 'btrfs fi defrag <file>' does not, only file ownership (or writing
permision). Is this on purpose?

Regards,
Lluís.
