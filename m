Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:60668 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab3GBHYi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 03:24:38 -0400
Message-ID: <51D28034.4050509@jan-o-sch.net>
Date: Tue, 02 Jul 2013 09:24:36 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: hold the tree mod lock in __tree_mod_log_rewind
References: <1372562251-27123-1-git-send-email-jbacik@fusionio.com> <51CFEB61.1040008@jan-o-sch.net> <20130630135548.GC4288@localhost.localdomain>
In-Reply-To: <20130630135548.GC4288@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, June 30, 2013 at 15:55 (+0200), Josef Bacik wrote:
> On Sun, Jun 30, 2013 at 10:25:05AM +0200, Jan Schmidt wrote:
>> On 30.06.2013 05:17, Josef Bacik wrote:
>>> We need to hold the tree mod log lock in __tree_mod_log_rewind since we walk
>>> forward in the tree mod entries, otherwise we'll end up with random entries and
>>> trip the BUG_ON() at the front of __tree_mod_log_rewind.  This fixes the panics
>>> people were seeing when running
>>>
>>> find /whatever -type f -exec btrfs fi defrag {} \;
>>
>> This patch cannot help to solve the problem, as far as I've understood
>> what is going on. It does change timing, though, which presumably makes
>> it pass the current reproducer we're having.
>>
>> On rewinding, iteration through the tree mod log rb-tree goes backwards
>> in time, which means that once we've found our staring point we cannot
>> be trapped by later additions. The old items we're rewinding towards
>> cannot be freed, because we've allocated a blocker element within the
>> tree and rewinding never goes beyond the allocated blocker. The blocker
>> element is allocated by btrfs_get_tree_mod_seq and mostly referred to as
>> time_seq within the other tree mod log functions in ctree.c. To sum up,
>> the added lock is not required.
>>
>> The debug output I've analyzed so far shows that after we've rewinded
>> all REMOVE_WHILE_FREEING operations on a buffer, ordered consecutively
>> as expected, there comes another REMOVE_WHILE_FREEING with a sequence
>> number much further in the past for the same buffer (but that sequence
>> number is still higher than out time_seq rewind barrier at that point).
>> This must be a logical problem I've not completely understood so far,
>> but locking doesn't seem to be the right track.
>>
> 
> Finally reproduced it, this is my output
> 
>  btrfs-endio-wri-23110 [000] ...2  9556.882103: __tree_mod_log_rewind: rewinding 15450537984
>  btrfs-endio-wri-23110 [000] ...2  9556.882104: __tree_mod_log_rewind: 15450537984: processing ffff880246590a40, op 3, seq 68719476829, slot 0
>  btrfs-endio-wri-23110 [000] ...2  9556.882106: __tree_mod_log_rewind: 15450537984: processing ffff880246590ac0, op 3, seq 68719476828, slot 1
>  btrfs-endio-wri-23110 [000] ...2  9556.882108: __tree_mod_log_rewind: 15450537984: processing ffff880246590a40, op 3, seq 68719476829, slot 0
>  btrfs-endio-wri-23110 [000] ...2  9556.882110: __tree_mod_log_rewind: 15450537984: this tm is failing, ffff880246590a40, seq 68719476829, slot 0
> 
> so I'm inclined to beleive I've got it right.  Thanks,

Looking at the code I agree we should have a read lock around rb_next,
protecting it against reorganization during insertions. Fits to that kind of
debug output.

How about just getting the lock for the rb_next call? There can be quite a lot
of operations to rewind and I'd rather not have every other fs tree modification
block on that.

Thanks,
-Jan

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
