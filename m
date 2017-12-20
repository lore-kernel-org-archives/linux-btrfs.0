Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:41615 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755637AbdLTVAB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 16:00:01 -0500
Received: by mail-io0-f176.google.com with SMTP id o2so18719501ioe.8
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 13:00:01 -0800 (PST)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 20 Dec 2017 23:59:20 +0300
Message-ID: <CAGqmi740EcovePxQswsZ=yh9E5Y1zLKCBaTvFN0EE_AuVPpQ7A@mail.gmail.com>
Subject: Btrfs allow compression on NoDataCow files? (AFAIK Not, but it does)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How reproduce:
touch test_file
chattr +C test_file
dd if=/dev/zero of=test_file bs=1M count=1
btrfs fi def -vrczlib test_file
filefrag -v test_file

test_file
Filesystem type is: 9123683e
File size of test_file is 1048576 (256 blocks of 4096 bytes)
ext:     logical_offset:        physical_offset: length:   expected: flags:
  0:        0..      31:   72917050..  72917081:     32:             encoded
  1:       32..      63:   72917118..  72917149:     32:   72917082: encoded
  2:       64..      95:   72919494..  72919525:     32:   72917150: encoded
  3:       96..     127:   72927576..  72927607:     32:   72919526: encoded
  4:      128..     159:   72943261..  72943292:     32:   72927608: encoded
  5:      160..     191:   72944929..  72944960:     32:   72943293: encoded
  6:      192..     223:   72944952..  72944983:     32:   72944961: encoded
  7:      224..     255:   72967084..  72967115:     32:   72944984:
last,encoded,eof
test_file: 8 extents found

I can't found at now, where that error happen in code,
but it's reproducible on Linux 4.14.8

Thanks.

-- 
Have a nice day,
Timofey.
