From: David Nicol <davidnicol@gmail.com>
Subject: wishlist item: sqlite
Date: Wed, 7 Oct 2009 10:53:26 -0500
Message-ID: <934f64a20910070853q5eeb00c1lc46046241a80e8da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

my wishlist item is for btrfs to expose to user-space enough
functionality that keeping sqlite databases directly in the file
system instead of through its own abstraction in a file maintained in
the fs will be a  matter of replacing sqlite's btree.c file, and
referring to an sqlite database using whatever one uses to refer to a
btrfs subvolume, so the database would be "mounted" rather than
reading and writing through the file abstraction.

http://sqlite.org/images/arch2.gif is a block diagram of the sqlite
architecture, showing a clean line above the "backend" which hopefully
btrfs can offer an interface to match.

That would be cool!
