Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0044.outbound.protection.outlook.com ([104.47.37.44]:5856
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754785AbeBPOmg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 09:42:36 -0500
Subject: Re: Status of FST and mount times
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <82cda32d-8069-4a27-7f78-cf3242eeeb36@mendix.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <b45357dd-044c-bff8-8e1c-4c8a06fb9636@panasas.com>
Date: Fri, 16 Feb 2018 09:42:49 -0500
MIME-Version: 1.0
In-Reply-To: <82cda32d-8069-4a27-7f78-cf3242eeeb36@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/16/2018 09:20 AM, Hans van Kranenburg wrote:
> Well, imagine you have a big tree (an actual real life tree outside) and
> you need to pick things (e.g. apples) which are hanging everywhere.
> 
> So, what you need to to is climb the tree, climb on a branch all the way
> to the end where the first apple is... climb back, climb up a bit, go
> onto the next branch to the end for the next apple... etc etc....
> 
> The bigger the tree is, the longer it keeps you busy, because the apples
> will be semi-evenly distributed around the full tree, and they're always
> hanging at the end of the branch. The speed with which you can climb
> around (random read disk access IO speed for btrfs, because your disk
> cache is empty when first mounting) determines how quickly you're done.
> 
> So, yes.

Thanks Hans.  I will say multiple minutes (by the looks of things, I'll 
end up near to an hour for 60TB if this non-linear scaling continues) to 
mount a filesystem is undesirable, but I won't offer that criticism 
without thinking constructively for a moment:

Help me out by referencing the tree in question if you don't mind, so I 
can better understand the point of picking all these "apples" (I would 
guess for capacity reporting via df, but maybe there's more).

Typical disclaimer that I haven't yet grokked the various inner-workings 
of BTRFS, so this is quite possibly a terrible or unapproachable idea:

On umount, you must already have whatever metadata you were doing the 
tree walk on mount for in-memory (otherwise you would have been able to 
lazily do the treewalk after a quick mount).  Therefore, could we not 
stash this metadata at or associated with, say, the root of the 
subvolumes?  This way you can always determine on mount quickly if the 
cache is still valid (i.e., no situation like: remount with old btrfs, 
change stuff, umount with old btrfs, remount with new btrfs, pain).  I 
would guess generation would be sufficient to determine if the cached 
metadata is valid for the given root block.

This would scale with number of subvolumes (but not snapshots), and 
would be reasonably quick I think.

Thoughts?

ellis
