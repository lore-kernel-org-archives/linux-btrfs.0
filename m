From: Leszek Ciesielski <skolima@gmail.com>
Subject: "No filesystem could mount root" after adding a second device to fs
Date: Mon, 30 Nov 2009 12:41:29 +0100
Message-ID: <23a15590911300341t6d4a73f5qc41fbea063d93cdf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

after adding a second device to a btrfs filesystem (kernel 2.6.31)
used for root fs, I am getting a "No filesystem could mount root"
message upon reboot. Is the caveat

"btrfsctl -a is used to scan all of the block devices under /dev and
probe for Btrfs volumes. This is required after loading the btrfs
module if you're running with more than one device in a filesystem. "

still true? If yes, is there a technical reason for it - am I wrong to
assume that btrfs could execute the scan upon mount request when the
filesystem requires it for assembling?

Regards,

Leszek 'skolima' Ciesielski
