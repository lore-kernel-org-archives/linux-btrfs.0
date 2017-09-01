Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752114AbdIAOsf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 10:48:35 -0400
Date: Fri, 1 Sep 2017 16:47:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@libero.it>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Piotr Szymaniak <szarpaj@grubelek.pl>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: [PATCH] btrfs: incorrect invalid lookup_path_rootid() error
 handling
Message-ID: <20170901144706.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818070421.2696-1-kreijack@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818070421.2696-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 09:04:19AM +0200, Goffredo Baroncelli wrote:
> Hi All,
> 
> Piotr and Chris, pointed me at these bugs which could be triggered by this test case:
> 
> # btrfs sub create test1
> # btrfs sub create test1/test2
> # btrfs sub snap test1 test1.snap
> # btrfs fi du -s test1
>      Total   Exclusive  Set shared  Filename
>      0.00B       0.00B       0.00B  test1
> # btrfs fi du -s test1.snap
>      Total   Exclusive  Set shared  Filename
> ERROR: cannot check space of 'test1.snap': Inappropriate ioctl for device
> 
> These are two bugs:
> 1) in the function du_walk_dir() the error returned by du_add_file() normally
> is ignored. But if du_walk_dir() "walks" the last items, the error is returned
> to the caller
> 2) in the function du_add_file() it doesn't make sense to call
> lookup_path_rootid() when the inode is BTRFS_EMPTY_SUBVOL_DIR_OBJECTID: in this
> case the function doesn't return a valid value.

Thanks, patches applied and I've added a testcase following the
instructions above.
