Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323AbbIYN4a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:56:30 -0400
Date: Fri, 25 Sep 2015 15:55:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: provide fail safe for
 BTRFS_IOC_GET_FSLABEL ioctl
Message-ID: <20150925135532.GG11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1442306783-1288-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442306783-1288-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 15, 2015 at 04:46:22PM +0800, Anand Jain wrote:
>  Old kernel like 2.6.32 does not provide ioctl BTRFS_IOC_GET_FSLABEL.
>  So we need to provide a fail safe logic for btrfs-progs running
>  on those kernel.
> 
>  In this patch when get_label_mounted() fails on the old kernel
>  it will fail back to the old method and uses get_label_unmounted(),
>  where it will read from the disk directly.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, thanks. I've changed the reference to 3.9 where the label ioctl
has been introduced.
