Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48564 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752153AbeBWWPL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:15:11 -0500
Date: Fri, 23 Feb 2018 23:12:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix bare unsigned declarations
Message-ID: <20180223221252.GN1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213165849.GZ3003@twin.jikos.cz>
 <20180214171300.5809-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180214171300.5809-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 01:13:00AM +0800, Anand Jain wrote:
> We have btrfs_fs_info::data_chunk_allocations and
> btrfs_fs_info::metadata_ratio declared as unsigned which would
> be unsinged int and kernel style prefers unsigned int over bare
> unsigned. So this patch changes them to u32.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Please also update the temporary variable old_metadata_ratio in
btrfs_remount that get assigned from one of the variables.
