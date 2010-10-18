From: David Nicol <davidnicol@gmail.com>
Subject: newbie question about struct btrfs_dir_item *btrfs_match_dir_item_name
Date: Mon, 18 Oct 2010 09:14:19 -0500
Message-ID: <AANLkTikQ94sEbBr8zg7RW5PPRKARFEEhENhXquS=e_Ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

reading, in dir-item.c, the code in
struct btrfs_dir_item *btrfs_match_dir_item_name (...)
I am a little surprised to see an O(n) iterative name comparison check
instead of something that would
efficiently support directories with lots of items in them. Is this
function a fall-back if a O(1) table lookup
somewhere else misses, perhaps?



-- 
"In one instance, a rai being transported by canoe was accidentally
dropped and sunk to the sea floor. Although it was never seen again,
everyone agreed that the rai must still be there, so it continued to
be transacted as genuine currency" -- Wikipedia
