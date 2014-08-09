Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11859 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbaHIUZj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Aug 2014 16:25:39 -0400
Message-ID: <53E683B6.6080400@fb.com>
Date: Sat, 9 Aug 2014 16:25:26 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <stable@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix csum tree corruption, duplicate and outdated
 checksums
References: <1407615747-12949-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1407615747-12949-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/09/2014 04:22 PM, Filipe Manana wrote:
> Under rare circumstances we can end up leaving 2 versions of a checksum
> for the same file extent range.
> 
> The reason for this is that after calling btrfs_next_leaf we process
> slot 0 of the leaf it returns, instead of processing the slot set in
> path->slots[0]. Most of the time (by far) path->slots[0] is 0, but after
> btrfs_next_leaf() releases the path and before it searches for the next
> leaf, another task might cause a split of the next leaf, which migrates
> some of its keys to the leaf we were processing before calling
> btrfs_next_leaf(). In this case btrfs_next_leaf() returns again the
> same leaf but with path->slots[0] having a slot number corresponding
> to the first new key it got, that is, a slot number that didn't exist
> before calling btrfs_next_leaf(), as the leaf now has more keys than
> it had before. So we must really process the returned leaf starting at
> path->slots[0] always, as it isn't always 0, and the key at slot 0 can
> have an offset much lower than our search offset/bytenr.

And the bug goes all the way back to 2007.  I'd like to blame Yan Zheng,
but it was in my original code too.

Great find and explanation, I've added this to my merge window pull.
Thanks!

-chris
