Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:59505 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaLNC7y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 21:59:54 -0500
Received: by mail-vc0-f171.google.com with SMTP id hy4so4611189vcb.30
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 18:59:53 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 14 Dec 2014 06:29:53 +0330
Message-ID: <CABvhJLiV4iPkin_XU-Ud3a0KiOLNv07m6whqZtNymDQd+1WHGw@mail.gmail.com>
Subject: subvolume / folder compression flag
From: Ali AlipourR <alipoor90@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

1- Do setting compression flag per subvolume is implemented?
(I did read on wiki that it is not implemented, but I can set it via
"btrfs  property")

2- If I set compression flag via "btrfs property" or "chattr" on a
subvolume, and rsync files without compression flag from ext4 file
system and preserve attributes by rsync -AX, do these files on that
btrfs subvolume will be compressed?
I mean do files will be compressed even if their compression flag
wasn't set, and just their subvolume compression flag was set?

3- what if I do same as 2 but on normal folder instead of subvolume
(chattr +c that folder), Do files within that folder will be
compressed even if their compression flag wasn't set?

Thanks,
Ali
