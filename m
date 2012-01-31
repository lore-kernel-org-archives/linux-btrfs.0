From: Hans Stimer <hans.stimer@gmail.com>
Subject: Packed small files
Date: Tue, 31 Jan 2012 08:21:30 -0800
Message-ID: <CAJJ3ruHxPqL6YRktpK+5V7Hgn2aAe=BCJLyicoLmYkxO4sVh1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

How space efficient are packed small files? For instance, if I have a
10,000 16 byte files with 16 byte file names, how much disk space will
they use? Are there any caveats or gotchas around using btrfs to store
millions of small (size<64bytes) files?
