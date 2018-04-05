Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sgisoft.es ([87.106.190.187]:49558 "EHLO
        s17634251.onlinehome-server.info" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751195AbeDEL1b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 07:27:31 -0400
Received: from sgisoft.sgisoft.pri (19.red-83-41-228.dynamicip.rima-tde.net [83.41.228.19])
        by s17634251.onlinehome-server.info (Postfix) with ESMTPSA id 6C8CA1000B64C
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Apr 2018 13:27:28 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
 by sgisoft.sgisoft.pri (Postfix) with ESMTP id AFE03711545
 for <linux-btrfs@vger.kernel.org>; Thu,  5 Apr 2018 13:27:27 +0200 (CEST)
Received: from sgisoft.sgisoft.pri ([127.0.0.1])
 by localhost (sgisoft.sgisoft.pri [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EmQX96te36Fe for <linux-btrfs@vger.kernel.org>;
 Thu,  5 Apr 2018 13:27:25 +0200 (CEST)
Received: from pcsenen.localnet (unknown [10.10.10.2])
 by sgisoft.sgisoft.pri (Postfix) with ESMTPSA id E212871153B
 for <linux-btrfs@vger.kernel.org>; Thu,  5 Apr 2018 13:27:24 +0200 (CEST)
From: =?ISO-8859-1?Q?Sen=E9n?= Vidal Blanco <senenvidal@sgisoft.com>
To: linux-btrfs@vger.kernel.org
Subject: Couldn't read tree root BTRFS - SEED
Date: Thu, 05 Apr 2018 13:27:23 +0200
Message-ID: <1816851.fIrENY6aja@pcsenen>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4914350.LVGhVFEqg4";
 micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4914350.LVGhVFEqg4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Hello,
I have a problem when mounting the btrfs system with two units (one in SEED 
mode and the other in read-write mode)
 
Initially it is functioning correctly in production:
 
btrfs fi sh 
Label: 'SEED_MD2'  uuid: 285b16fa-b297-43ed-bb3b-311950729eb6 
       Total devices 2 FS bytes used 2.00TiB 
       devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1 
       devid    2 size 1.80TiB used 119.03GiB path /dev/bcache0 
 
Label: 'BOOT'  uuid: ce8fd2ef-975c-417a-b90c-280f8d324c44 
       Total devices 1 FS bytes used 536.86MiB 
       devid    1 size 1.86GiB used 1.15GiB path /dev/md1 
 
Label: 'SEED_MD2'  uuid: 851e4474-d375-4a25-b202-949e51f05877 
       Total devices 1 FS bytes used 1.94TiB 
       devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1
 
The bcache0 and bcache1 units are what I mention.
bcache1 is the SEED
bcache0 is the read-write
 
When it comes to mounting the two copy mirror devices that is in production I 
have this result:
 
parent transid verify failed on 2184045428736 wanted 269593 found 266275 
parent transid verify failed on 2184045428736 wanted 269593 found 266275 
Ignoring transid failure 
Couldn't map the block 2287467560960 
No mapping for 2287467560960-2287467577344 
Couldn't map the block 2287467560960 
bytenr mismatch, want=2287467560960, have=0 
Couldn't read tree root 
Label: 'SEED_MD2'  uuid: 851e4474-d375-4a25-b202-949e51f05877 
       Total devices 1 FS bytes used 1.94TiB 
       devid    1 size 5.44TiB used 1.97TiB path /dev/bcache1 
 
Label: 'SEED_MD2'  uuid: 285b16fa-b297-43ed-bb3b-311950729eb6 
       Total devices 2 FS bytes used 1.98TiB 
       devid    2 size 1.80TiB used 102.03GiB path /dev/bcache2 
       *** Some devices missing
 
Would there be any way to tell BTRFS that the missing unit is the one that 
corresponds to the SEED unit so that it correctly rebuilds the file system?

Thank you.


--nextPart4914350.LVGhVFEqg4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSK7dSjHxedEO9Hp55GZDGorwH5mgUCWsYIGwAKCRBGZDGorwH5
mlzjAKDXofN7t35worWAdIrE4j7AY8lrIACbB0QTF6Wm7g7LfQCONwI2mdFEVOw=
=Xbdq
-----END PGP SIGNATURE-----

--nextPart4914350.LVGhVFEqg4--

