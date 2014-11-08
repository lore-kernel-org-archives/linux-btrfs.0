Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:42224 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbaKHB0i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 20:26:38 -0500
Message-ID: <545D714B.2000207@pobox.com>
Date: Fri, 07 Nov 2014 17:26:35 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: make xattr replace operations atomic
References: <1415392765-1877-1-git-send-email-fdmanana@suse.com> <1415408514-17845-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1415408514-17845-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/07/2014 05:01 PM, Filipe Manana wrote:
> V2: Added missing btrfs_mark_buffer_dirty() call for the case where a replace
>      happens for an item with no other xattrs and the new xattr value size is
>      the same as the old xattr value size;
>      Made btrfs_search_slot not release the path if it returns EOVERFLOW (from
>      split_leaf), so that we can get the current size of the item when doing
>      the replace and extend the leaf to a size smaller then what we passed to
>      btrfs_search_slot if the xattr exists in the item (and the new extend size
>      is new_size - old_size, excluding xattr's name and sizeof struct btrfs_dir_item).

Stupid Question Here: How does this "replace and extend" affect the 
whole copy-on-write paradigm. Aren't you now overwriting the contents of 
the old data instead of doing a COW?

Not a passive-aggressive commentary question, I genuinely don't 
understand this piece of code so I am seeking a learning opportunity.
