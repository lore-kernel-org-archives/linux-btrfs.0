Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbbAMSS3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 13:18:29 -0500
Date: Tue, 13 Jan 2015 19:18:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@gmail.com
Subject: Re: [PATCH 1/1 v2] Btrfs: fix unused members in struct btrfs_root
Message-ID: <20150113181828.GL3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421081710-5005-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421081710-5005-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 13, 2015 at 12:55:10AM +0800, Anand Jain wrote:
> There isn't any real use of following members of struct btrfs_root
> so delete them.
> 
> struct kobject root_kobj;
> struct completion kobj_unregister;
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
