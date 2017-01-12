Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbdALPXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 10:23:51 -0500
Date: Thu, 12 Jan 2017 16:03:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Milan Stephan <milan.stephan@fau.de>
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Milan Stephan <milan.stephan+linux@fau.de>,
        Thomas Preisner <thomas.preisner+linux@fau.de>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@i4.cs.fau.de, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: uuid-tree: btrfs_uuid_tree_iterate: fix improper
 return value
Message-ID: <20170112150351.GM12081@suse.cz>
Reply-To: dsterba@suse.cz
References: <1484232945-45624-1-git-send-email-milan.stephan@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484232945-45624-1-git-send-email-milan.stephan@fau.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2017 at 03:55:45PM +0100, Milan Stephan wrote:
> From: Milan Stephan <milan.stephan+linux@fau.de>
> 
> Fixes return value of btrfs_uuid_tree_iterate to catch and return errors
> when calling btrfs_alloc_path.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188731

The patch for that has been already sent and merged to for-next,
https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git/commit/?h=for-next&id=73ba39ab9307340dc98ec3622891314bbc09cc2e

but thanks anyway.
