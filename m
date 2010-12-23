From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: kernel BUG
Date: Thu, 23 Dec 2010 19:12:13 +0100
Message-ID: <20101223191213.50848c09@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I got a kernel BUG at

fs/btrfs/disk-io.c:2311

when testing the 2.6.37-rc5 kernel today.

The system crashed while doing really nothing for a few minutes.

Greetings, Michael
