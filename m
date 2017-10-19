Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57275 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdJSDOs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 23:14:48 -0400
Subject: Re: [PATCH 01/21] Btrfs: rework outstanding_extents
To: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-2-git-send-email-jbacik@fb.com>
From: Edmund Nadolski <enadolski@suse.de>
Message-ID: <5ef9232a-5b5c-0660-3d11-c453c65f70d1@suse.de>
Date: Wed, 18 Oct 2017 21:14:31 -0600
MIME-Version: 1.0
In-Reply-To: <1506714245-23072-2-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

just a few quick things for the changelog:

On 09/29/2017 01:43 PM, Josef Bacik wrote:
> Right now we do a lot of weird hoops around outstanding_extents in order
> to keep the extent count consistent.  This is because we logically
> transfer the outstanding_extent count from the initial reservation
> through the set_delalloc_bits.  This makes it pretty difficult to get a
> handle on how and when we need to mess with outstanding_extents.
> 
> Fix this by revamping the rules of how we deal with outstanding_extents.
> Now instead everybody that is holding on to a delalloc extent is
> required to increase the outstanding extents count for itself.  This
> means we'll have something like this
> 
> btrfs_dealloc_reserve_metadata	- outstanding_extents = 1

s/dealloc/delalloc/


>  btrfs_set_delalloc		- outstanding_extents = 2

should be btrfs_set_extent_delalloc?


> btrfs_release_delalloc_extents	- outstanding_extents = 1
> 
> for an initial file write.  Now take the append write where we extend an
> existing delalloc range but still under the maximum extent size
> 
> btrfs_delalloc_reserve_metadata - outstanding_extents = 2
>   btrfs_set_delalloc

btrfs_set_extent_delalloc?


>     btrfs_set_bit_hook		- outstanding_extents = 3
>     btrfs_merge_bit_hook	- outstanding_extents = 2

should be btrfs_clear_bit_hook? (or btrfs_merge_extent_hook?)


> btrfs_release_delalloc_extents	- outstanding_extnets = 1

btrfs_delalloc_release_metadata?


> 
> In order to make the ordered extent transition we of course must now
> make ordered extents carry their own outstanding_extent reservation, so
> for cow_file_range we end up with
> 
> btrfs_add_ordered_extent	- outstanding_extents = 2
> clear_extent_bit		- outstanding_extents = 1
> btrfs_remove_ordered_extent	- outstanding_extents = 0
> 
> This makes all manipulations of outstanding_extents much more explicit.
> Every successful call to btrfs_reserve_delalloc_metadata _must_ now be
                           ^
btrfs_delalloc_reserve_metadata?


Thanks,
Ed

