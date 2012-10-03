Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53616 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab2JCSyv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 14:54:51 -0400
Date: Wed, 3 Oct 2012 14:54:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Wade Cline <clinew@linux.vnet.ibm.com>
Cc: "cmm@linux.vnet.ibm.com" <cmm@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [e2fsprogs] ext2_dir_entry To ext2_dir_entry_2 Casting
Message-ID: <20121003185445.GA5160@thunk.org>
References: <506B31B7.40405@linux.vnet.ibm.com>
 <506B3A3E.1060003@linux.vnet.ibm.com>
 <20121002210836.GA15277@thunk.org>
 <506C786B.4080704@linux.vnet.ibm.com>
 <20121003175831.GC4237@thunk.org>
 <506C8426.4010008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <506C8426.4010008@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 11:29:58AM -0700, Wade Cline wrote:
> In this case, dir_iterate_proc() is being passed into
> ext2_dir_iterate2() and is called from ext2fs_process_dir_block(),
> not readdir(2). It looks like the main issue would be detecting if the
> EXT2_FEATURE_INCOMPAT_FILETYPE flag is -unset- and manually
> setting the file type to EXT2_FT_UNKNOWN (there appears to be a case for
> handling EXT2_FT_UNKNOWN; so long as the file type is not set to an
> undefined value it should be okay).

EXT2_FT_UNKNOWN == DT_UNKNOWN == 0

Since we've always enforced that name_len < 256, the high 8 bits
of name_len will always be zero, even if !EXT2_FEATURE_INCOMPAT_FILETYPE.

							- Ted
