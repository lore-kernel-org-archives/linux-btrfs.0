Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964902AbeBLQiV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 11:38:21 -0500
Date: Mon, 12 Feb 2018 17:34:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use set functions to update latest refs to the SB
Message-ID: <20180212163443.GI3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180212153749.19705-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180212153749.19705-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 11:37:49PM +0800, Anand Jain wrote:
> We have btrfs_set_super...() to set the various values, so just use it.

Sorry but this is not "just use it", as it fixes an endianness bug and
should be documented in the changelog. And there are probably more
instances of the bug while accessing fs_info::super or
fs_info::super_copy directly.
