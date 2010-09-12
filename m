From: David Nicol <davidnicol@gmail.com>
Subject: reserving an IOCTL number; other details
Date: Sun, 12 Sep 2010 14:40:44 -0500
Message-ID: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have written and am currently testing a patch that provides a new
ioctl that waits for snapshot deletion to finish before returning; The
work is being sponsored, and I can't distribute it until the
sponsorship details are more solid, but I'd like to reserve ioctl #21
for this purpose (the next one from btrfs-unstable) or receive advice
on what ioctl number to use instead.

Also, if you would like to test this function on a trade-secret basis
(until the sponsorship comes through) please contact me off-list.

David Nicol

--=20
l'=C3=A9galit=C3=A9 des droits pour les ambidextres
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
