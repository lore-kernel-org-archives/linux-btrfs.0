Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:32913 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbbGIBUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 21:20:48 -0400
Received: by laar3 with SMTP id r3so236993462laa.0
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 18:20:46 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Jul 2015 21:20:46 -0400
Message-ID: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
Subject: btrfs subvolume clone or fork (btrfs-progs feature request)
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Request for new btrfs subvolume subcommand:

clone or fork [-i <qgroupid] <source> [<dest>]<name>
   Create a subvolume <name> in <dest>, which is a clone or fork of source.
   If <dest> is not given, subvolume <name> will be created in the
current directory.
   Options
   -i <qgroupid>
      Add the newly created subvolume to a qgroup.  This option can be
given multiple times.

Would (I think):
* btrfs subvolume create <dest-subvolume>
* cp -ax --reflink=always <source-subvolume>/* <dest-subvolume>/


Particularly useful to avoid "Invalid cross-device link" when using cp
-ax, when source and dest are seen as different devices.

Such as if there is a top-level subvolume mounted as /, with others
mounted elsewhere.  Required workaround is to mount with subvolid=0 to
/mnt, cp -ax --reflink=always /mnt/...source /mnt/...dest
