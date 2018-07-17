Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59276 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729602AbeGQP5w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 11:57:52 -0400
Date: Tue, 17 Jul 2018 17:24:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: rename btrfs_parse_early_options
Message-ID: <20180717152436.GC3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180716141807.18551-1-anand.jain@oracle.com>
 <80318d04-43fb-71a4-8a0d-f0c254d9f128@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <80318d04-43fb-71a4-8a0d-f0c254d9f128@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2018 at 11:01:37PM +0800, Anand Jain wrote:
> On 07/16/2018 10:18 PM, Anand Jain wrote:
> > Rename btrfs_parse_early_options() to btrfs_parse_device_options(). As
> > btrfs_parse_early_options() parses the -o device options and scan the
> > device provided. So this rename specifies its action. Also the function
> > name is inline with btrfs_parse_subvol_options().

Yeah, much more fitting name.

> > No functional changes.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> 
> Forgot to mention: This should be applied on top of
>    Gu Jinxiang (2):
>    btrfs: make fs_devices to be a local variable
>    btrfs: get device pointer from btrfs_scan_one_device

Both are in misc-next now so your patch applied too, thanks.
