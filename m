Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752552AbdEIPPJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 11:15:09 -0400
Date: Tue, 9 May 2017 17:15:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Daichou <tommy0705c@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs:Unused comments:"FIXME: check if the IDs really
 exist" in ioctl.c
Message-ID: <20170509151501.GE5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170508021002.12262-1-tommy0705c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170508021002.12262-1-tommy0705c@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 08, 2017 at 10:10:02AM +0800, Daichou wrote:
> These comments were already fixed in 2013.

> btrfs_add_qgroup_relation, btrfs_ioctl_qgroup_create, btrfs_limit_qgroup
> btrfs_add_qgroup_relation, btrfs_del_qgroup_relation have checked qgroupid existed.

Patch is ok, thanks. (I'll just reformat the changelog.)
