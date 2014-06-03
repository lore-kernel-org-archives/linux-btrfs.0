Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbaFCNX2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 09:23:28 -0400
Date: Tue, 3 Jun 2014 15:23:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 2/6 v2] btrfs: dev delete should remove sysfs entry
Message-ID: <20140603132326.GJ22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
 <1401766564-7381-3-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401766564-7381-3-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 11:36:00AM +0800, Anand Jain wrote:
> when we delete the device from the mounted btrfs,
> we would need its corresponding sysfs enty to
> be removed as well.
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
