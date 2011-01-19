From: Rodney Beede <mailinglist@rodneybeede.com>
Subject: List of compressed files
Date: Tue, 18 Jan 2011 17:08:45 -0700
Message-ID: <AANLkTi=OpXSXQMB9ydFhAuB05N3tySWe6vpSTeAkVG46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I looked through the man page and wiki but didn't see a command to
list all files on a mount point that are compressed.

A command that could do the following would be nice:

Full Pathame     Compressed Size Bytes     Uncompressed Size Bytes
Compression Ratio
/some/file       1500                      3000                        0.5
/some/file2      1200                      2400                        0.5
