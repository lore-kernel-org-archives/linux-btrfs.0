Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbaFCNjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 09:39:43 -0400
Date: Tue, 3 Jun 2014 15:39:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 4/6 v2] btrfs: dev replace should replace the sysfs entry
Message-ID: <20140603133941.GM22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
 <1401766564-7381-5-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401766564-7381-5-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 11:36:02AM +0800, Anand Jain wrote:
> when we replace the device its corresponding sysfs
> entry has to be replaced as well
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
