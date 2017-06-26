Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55071 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751415AbdFZQtA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 12:49:00 -0400
Date: Mon, 26 Jun 2017 18:47:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 03/11] btrfs: Don't clear SGID when inheriting ACLs
Message-ID: <20170626164739.GP2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170622133115.16968-1-jack@suse.cz>
 <20170622133115.16968-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170622133115.16968-4-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 03:31:07PM +0200, Jan Kara wrote:
> When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
> set, DIR1 is expected to have SGID bit set (and owning group equal to
> the owning group of 'DIR0'). However when 'DIR0' also has some default
> ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
> 'DIR1' to get cleared if user is not member of the owning group.
> 
> Fix the problem by moving posix_acl_update_mode() out of
> __btrfs_set_acl() into btrfs_set_acl(). That way the function will not be
> called when inheriting ACLs which is what we want as it prevents SGID
> bit clearing and the mode has been properly set by posix_acl_create()
> anyway.
> 
> Fixes: 073931017b49d9458aa351605b43a7e34598caef
> CC: stable@vger.kernel.org
> CC: linux-btrfs@vger.kernel.org
> CC: David Sterba <dsterba@suse.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Added to btrfs patch queue, thanks.
