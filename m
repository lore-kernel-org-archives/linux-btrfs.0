From: =?ISO-8859-1?Q?I=F1igo_Mart=EDnez?= <inigomartinez@gmail.com>
Subject: Invalid snapshot fallback
Date: Mon, 01 Aug 2011 18:47:49 +0200
Message-ID: <1312217274.3449.9.camel@praevus>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello:

Sorry if this has been asked before, but I haven't found any related
information. This fails:

  1. create an snapshot.
  2. mark it as the default.
  3. remove the snapshot.
  4. umount the volume and mount it again.

My question is, shouldn't it mount the top level path as a fall back if
the default snapshot doesn't exists or fails to mount ?

Regards,


