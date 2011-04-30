From: Evert Vorster <evorster@gmail.com>
Subject: Rename a btrfs filesystem?
Date: Fri, 29 Apr 2011 21:24:16 -0500
Message-ID: <BANLkTikxuU4z-LXUcQptuaLZSZvUjmQSsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there.

Just a quick question: How do I rename an existing btrfs filesystem
without destroying all the subvolumes on it?

>From mkfs.btrfs it says -L sets the initial filesystem label.

With ext2, 3 and 4 the filesystem label can be changed with tune2fs.
Does similar functionality exist in btrfs?

Thanks for any response.
-- 
-Evert-
