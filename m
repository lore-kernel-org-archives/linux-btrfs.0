Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59953 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaDZS5K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 14:57:10 -0400
Message-ID: <535C017C.7060509@gmx.de>
Date: Sat, 26 Apr 2014 20:57:00 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: superfluous " else if ()"
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

/me wonders if this

        if (ret >= 0) {
                /* Add an item for the type for the first time */
                eb = path->nodes[0];
                slot = path->slots[0];
                offset = btrfs_item_ptr_offset(eb, slot);
        } else if (ret == -EEXIST) {
                /*
                 * An item with that type already exists.
                 * Extend the item and store the new subid at the end.
                 */
                btrfs_extend_item(uuid_root, path, sizeof(subid_le));
                eb = path->nodes[0];
                slot = path->slots[0];
                offset = btrfs_item_ptr_offset(eb, slot);
                offset += btrfs_item_size_nr(eb, slot) - sizeof(subid_le);
        } else if (ret < 0) {							<-----------------
                btrfs_warn(uuid_root->fs_info, "insert uuid item failed %d "
                        "(0x%016llx, 0x%016llx) type %u!",
                        ret, (unsigned long long)key.objectid,
                        (unsigned long long)key.offset, type);
                goto out;
        }


shouldn't be condensed into just "} else {" ?

-- 
Toralf

