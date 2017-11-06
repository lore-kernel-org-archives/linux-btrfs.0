Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754298AbdKFQwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 11:52:04 -0500
Date: Mon, 6 Nov 2017 17:50:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] btrfs: optimize use of volume_mutex in
 btrfs_ioctl_resize()
Message-ID: <20171106165010.GP28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106083618.7617-1-anand.jain@oracle.com>
 <20171106083618.7617-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106083618.7617-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 04:36:12PM +0800, Anand Jain wrote:
> We can push volume_mutex lock further down after the memory operation.

I'm a bit reluctant to apply any patches that cleanup volume_mutex as
it's going to be removed.
