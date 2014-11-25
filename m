Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:36130 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKYFEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 00:04:55 -0500
Received: by mail-ob0-f179.google.com with SMTP id va2so8371258obc.10
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 21:04:54 -0800 (PST)
MIME-Version: 1.0
From: Daniel Miranda <danielkza2@gmail.com>
Date: Tue, 25 Nov 2014 03:04:34 -0200
Message-ID: <CAPRQymMYBhy0mxG1qTxqt2OGezm3qnq+rAZOLAk1TpkOoixNWw@mail.gmail.com>
Subject: Apparent metadata corruption (file that simultaneously does/does not
 exist) on kernel 3.17.3
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

After I had some brief stability issues with my computer, it seems
some form of metadata corruption took place in my BTRFS filesystem,
and now a particular file seems to exist, but I cannot access any
details on it or delete it.

If I try to `ls` in the directory it is in, that's what I get:

ls: cannot access string.h: No such file or directory
total 0
drwxr-xr-x. 1 danielkza mock 16 Nov 21 14:18 ./
drwxr-xr-x. 1 danielkza mock  6 Nov 21 14:18 ../
-?????????? ? ?         ?     ?            ? string.h

If I try to delete it I get:

rm: cannot remove ‘string.h’: No such file or directory

I'm using kernel 3.17.3 from Fedora 21. I got no messages on dmesg or
anything of the sort. I know the btrfs fsck situation is complicated,
but is there any utility I should use to try and repair this? Losing
this file is not a problem, it's just one header from the kernel I was
building.

Regards,
Daniel Miranda
