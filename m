Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2G3TzP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 15:55:15 -0400
Received: by eaak13 with SMTP id k13so1248441eaa.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 12:55:14 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Jul 2012 14:55:14 -0500
Message-ID: <CA+M2DjmS0xB8zinvELi5SBg1QRxabvHfpd1MqJxqCB65qq1ceA@mail.gmail.com>
Subject: balance disables nodatacow
From: Kyle Gates <kylegates@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 3 disk raid1 filesystem mounted with nodatacow. I have a
folder in said filesystem with the 'C' NOCOW & 'Z' Not_Compressed
flags set for good measure. I then copy in a large file and proceed to
make random modifications. Filefrag shows no additional extents
created, good so far. A big thank you to the those devs who got that
working.
However, after a balance run (which crashed btw), modifications to the
file result in increasing extent counts, ie. no longer obeying
nodatacow mount option nor the 'C' flag.
I realize that a balance will cow the data but it should not disable
the ability to make nodatacow inline changes to a file.

I'm currently running 3.5.0 mainline Ubuntu kernel with the latest
master of btrfs-progs from a ppa.

Thank you.
Kyle Gates
