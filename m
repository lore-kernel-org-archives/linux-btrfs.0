From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Atomic file data replace API
Date: Thu, 6 Jan 2011 21:01:15 +0100
Message-ID: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Does btrfs support atomic file data replaces? Basically, the atomic
variant of this:
// old stage
open(O_TRUNC)
write() // 0+ times
close()
// new state
-- 
Olaf
