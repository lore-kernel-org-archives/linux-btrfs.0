Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751176AbdI2Nsh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 09:48:37 -0400
Date: Fri, 29 Sep 2017 15:47:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Yingyi Luo <yingyil@google.com>
Cc: linux-btrfs@vger.kernel.org, drosen@google.com
Subject: Re: [PATCH 0/4 v2] add subvolume support to mkfs
Message-ID: <20170929134702.GO31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825232101.10859-1-yingyil@google.com>
 <20170830172450.27460-1-yingyil@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170830172450.27460-1-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 30, 2017 at 10:24:46AM -0700, Yingyi Luo wrote:
> From: yingyil <yingyil@google.com>
> 
> Hi all,
> 
> Thanks for all the comments you gave to me. I really appriciate it. I've
> updated the patch, split it into small ones so that it may be easier
> for you to see the changes and review.
> 
> One use case of this feature is that it allows easier operations on subvolumes,
> such as migrating subvolumes across images. With the current btrfs tool, we have
> to do this manually by creating an empty subvolume then moving the files over.
> This feature which creates a subvolume for a given directory when making btrfs
> images simplifies the process and makes the logic cleaner.
> 
> Goffredo: Thanks again for you comments and pointing out the bug. It happened
> to be that I skipped the error code checking when I tested the functionality.
> The error came from a duplicate call of btrfs_make_root_dir() from
> make_root_dir() in mkfs/main.c and create_subvol() in convert/main.c.
> 
> strdup() is used to get a returnable copy of the literal string.
> FYI, parse_label() used strdup() to parse the input string. I think using
> strdup() would make it consistent with the current code.
> 
> Extending the feature would be a good idea. I'll try to work on it later.
> 
> Best regards,
> Yingyi
> 
> yingyil (4):
>   btrfs-progs: convert: move link_subvol out of main
>   btrfs-progs: add a parameter to btrfs_link_subvol
>   btrfs-progs: mkfs: refactor create_data_reloc_tree
>   btrfs-progs: mkfs: add subvolume support to mkfs

The updated patches have been added to devel. Before this will be
released, the propsed semantics of subvol/rootdir will have to be
implemented.

At the moment, overlaying files from rootdir over any previously created
subvolume does not work, there are probably missing checks for existing
dirs so this ends up with a duplicate entry.
