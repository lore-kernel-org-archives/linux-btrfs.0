From: "Michael Niederle" <mniederle@gmx.at>
Subject: btrfs-images
Date: Wed, 4 Aug 2010 18:13:32 +0200
Message-ID: <20100804181332.1c5ea14a@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I also wanted to use btrfs-images, but changed my mind when I got troubles
with several btrfs file systems derived from the same image.

If more than one of these file system were physically connected at the same
time, mounting one of them resulted in a mess. I think they all used the same
internal ids and btrfs thought them to be one single file system stretched over
several media. So I decided to create a fresh btrfs file system every time and
copy the files from an archive (which is much slower).

Is there a workaround?

Greetings, Michael
