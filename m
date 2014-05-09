Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:65357 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbaEIRM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 13:12:57 -0400
Message-ID: <536D0C96.4020705@gmx.de>
Date: Fri, 09 May 2014 19:12:54 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: superfluous " else if ()"
References: <535C017C.7060509@gmx.de> <20140509164902.GA6039@twin.jikos.cz>
In-Reply-To: <20140509164902.GA6039@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2014 06:49 PM, David Sterba wrote:
> On Sat, Apr 26, 2014 at 08:57:00PM +0200, Toralf Förster wrote:
>> /me wonders if this
>>
>>         if (ret >= 0) {
>>                 /* Add an item for the type for the first time */
>>                 eb = path->nodes[0];
>>                 slot = path->slots[0];
>>                 offset = btrfs_item_ptr_offset(eb, slot);
>>         } else if (ret == -EEXIST) {
>>                 /*
>>                  * An item with that type already exists.
>>                  * Extend the item and store the new subid at the end.
>>                  */
>>                 btrfs_extend_item(uuid_root, path, sizeof(subid_le));
>>                 eb = path->nodes[0];
>>                 slot = path->slots[0];
>>                 offset = btrfs_item_ptr_offset(eb, slot);
>>                 offset += btrfs_item_size_nr(eb, slot) - sizeof(subid_le);
>>         } else if (ret < 0) {							<-----------------
>>                 btrfs_warn(uuid_root->fs_info, "insert uuid item failed %d "
>>                         "(0x%016llx, 0x%016llx) type %u!",
>>                         ret, (unsigned long long)key.objectid,
>>                         (unsigned long long)key.offset, type);
>>                 goto out;
>>         }
>>
>>
>> shouldn't be condensed into just "} else {" ?
> 
> It's equivalent to the original code, but is easier to read/understand.
> Do you have there other concerns besides readability?
> 

Oh no, if it is intended and b/c it is not in a runtime critical path - no.

But what came into my mind, wouldn't the following avoid such question in future ? :

         } else {
		/* ret < 0 */

-- 
Toralf

