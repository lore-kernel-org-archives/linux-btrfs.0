From: Nathan Caza <mastercactapus@gmail.com>
Subject: crc32c
Date: Mon, 11 Oct 2010 03:47:58 -0500
Message-ID: <AANLkTi=8xYEQ=pwo5faCMqD7gV=OLJxXTmfKvcDvp5i-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I think I'm on the verge of getting all my data back; the only missing
piece is to recalculate the crc checksum of my altered superblock and
I'm having trouble finding the correct function/method; the data I am
checksumming is (based on the sheet) 0x20 (directly after the
checksum) to 0x32b + n (226 bytes); if im doing something wrong let me
know; or if theres a quick/dirty way to get the right checksum

..soo close...
