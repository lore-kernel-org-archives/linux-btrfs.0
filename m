From: "Amr H. El-Sharnoby" <amr.el.sharnoby@gmail.com>
Subject: "df -i" should display how many inodes are used
Date: Mon, 23 Aug 2010 16:03:58 +0200
Message-ID: <AANLkTinBP3XnAo0zjL5nJhrvMOkmqjSWW7yv1GGv9oki@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I understand that btrfs doesn't have a hard limit to inodes, but you
know `df -i`  has three columns displayed "Inodes, IUsed, IFree" ...
The IUsed is so meaningful really and saves much time in some cases ..
And when you have millions of files, something like "find |wc -l"
would take ages to complete.

If there is any other way to know "how many files" are there on a
btrfs filesystem, please tell me.

Thanks a lot

-- Amr H. El-Sharnoby --
