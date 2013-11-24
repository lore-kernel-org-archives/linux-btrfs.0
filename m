Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58027 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab3KXSi2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 13:38:28 -0500
Received: from [192.168.10.114] ([85.181.13.11]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MHoWj-1VoEPf1xfx-003hGo for
 <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 19:38:26 +0100
Message-ID: <529247A2.4090905@gmx.de>
Date: Sun, 24 Nov 2013 19:38:26 +0100
From: Thomas Pasch <thomas.pasch@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: corrupt btrfs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

yes, I've got it. I know that btrfs is experimental, and I've got a
backup (well, it is a little bit older, but anyway...). I read
[https://btrfs.wiki.kernel.org/index.php/Problem_FAQ] and
[https://btrfs.wiki.kernel.org/index.php/Restore] and have done what it
is suggested there (including the problematic btrfs-zero-log !). In
addition, I run Ubuntu 13.10, that does rule me out from being a
sensible person.

Beside that, I tried btrfs-find-root. It shows something like:

Well block 144572416 seems great, but generation doesn't match,
have=250241, want=250412 level 0
Well block 252919808 seems great, but generation doesn't match,
have=250404, want=250412 level 0
Well block 282722304 seems great, but generation doesn't match,
have=250093, want=250412 level 0
Well block 291414016 seems great, but generation doesn't match,
have=250094, want=250412 level 0
Well block 302501888 seems great, but generation doesn't match,
have=250095, want=250412 level 0
Well block 310611968 seems great, but generation doesn't match,
have=249927, want=250412 level 0
Well block 319311872 seems great, but generation doesn't match,
have=250097, want=250412 level 0
[...]

What I'm missing here is some line starting with 'Generation: ...'.
Well, it is not there...

Certainly, the 'btrfs restore -t n /dev/sda7 /mnt/restore' trick does
not find anything useful.

Is there anything left I could try before giving up on this?

Kind regards,

Thomas

