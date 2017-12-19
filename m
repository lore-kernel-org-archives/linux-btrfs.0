Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:43366 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdLSTB3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 14:01:29 -0500
Received: by mail-pf0-f194.google.com with SMTP id e3so11500269pfi.10
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 11:01:29 -0800 (PST)
Date: Tue, 19 Dec 2017 11:01:25 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
Message-ID: <20171219190125.GA19899@vader.DHCP.thefacebook.com>
References: <20171219104511.3563-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171219104511.3563-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 06:45:11PM +0800, Qu Wenruo wrote:
> btrfs_qgroup_inherit structure has two members, num_ref_copies and
> num_excl_copies, to info btrfs kernel modules to inherit (copy)
> rfer/excl numbers at snapshot/subvolume creation time.
> 
> Since qgroup number is already hard to maintain for multi-level qgroup
> scenario, allowing user to manually manipulate qgroup inherit is quite
> easy to screw up qgroup numbers.
> 
> Although btrfs-progs supports such inheritance specification, the
> options are hidden from user and not documented.
> So there is no need to allow user to manually specify inheritance in
> kernel.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>

And reported to Nikolay by me ;)

My only objection is that we shouldn't rename the field names in the
UAPI header. Let's just add a comment that the two counters are ignored.
Besides that,

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> The only concern is, currently we don't have good tool to handle
> inheritance of multi-level qgroups.
> The only method to get qgroup numbers correct is to run a quota rescan.
> 
> So there may be some case where experienced (well, mostly a developer)
> user can use the hidden btrfs-progs options or manually craft an ioctl
> to handle multi-level qgroups without costly rescan.

If we want this functionality, we should add a specific ioctl for it
instead of piggy-backing off of subvolume creation.

Thanks!

> ---
>  fs/btrfs/qgroup.c          | 56 ++++++++++++++--------------------------------
>  include/uapi/linux/btrfs.h |  4 ++--
>  2 files changed, 19 insertions(+), 41 deletions(-)
