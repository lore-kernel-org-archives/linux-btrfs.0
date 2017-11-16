Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:60498 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933322AbdKPRgj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 12:36:39 -0500
Subject: Re: 4.13.12: kernel BUG at fs/btrfs/ctree.h:1802!
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
References: <20171116170445.24n57phzltgiehj6@merlins.org>
 <20171116170742.vyhxckxrgjzwqyvf@merlins.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <70b25128-d724-4e8e-9835-4a092cf8d5a6@applied-asynchrony.com>
Date: Thu, 16 Nov 2017 18:27:44 +0100
MIME-Version: 1.0
In-Reply-To: <20171116170742.vyhxckxrgjzwqyvf@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/16/17 18:07, Marc MERLIN wrote:
> Sorry, was missing the kernel number in the subject, just fixed that.
> 
> On Thu, Nov 16, 2017 at 09:04:45AM -0800, Marc MERLIN wrote:
>> My server now reboots every 20mn or so, with this.
>> Sadly another BUG_ON() and it won't even tell me which filesystem
>> it's on
>>
>> static inline u32 btrfs_extent_inline_ref_size(int type)
>> {
>> 	if (type == BTRFS_TREE_BLOCK_REF_KEY ||
>> 	    type == BTRFS_SHARED_BLOCK_REF_KEY)
>> 		return sizeof(struct btrfs_extent_inline_ref);
>> 	if (type == BTRFS_SHARED_DATA_REF_KEY)
>> 		return sizeof(struct btrfs_shared_data_ref) +
>> 		       sizeof(struct btrfs_extent_inline_ref);
>> 	if (type == BTRFS_EXTENT_DATA_REF_KEY)
>> 		return sizeof(struct btrfs_extent_data_ref) +
>> 		       offsetof(struct btrfs_extent_inline_ref, offset);
>> 	BUG();
>> 	return 0;
>> }

This BUG() was recently removed and seems to be caused by some kind
of persistent corruption, which is seen as invalid inline extent.
See [1], [2] for details. Maybe you can backport them?
Alternatively just give 4.14 a whirl, it's great.

-h

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=167ce953ca55bdee20fe56c3c0fa51002435f745
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4335958de2a43c6790c7f6aa0682aa7189983fa4
