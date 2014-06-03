Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbaFCNXo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 09:23:44 -0400
Date: Tue, 3 Jun 2014 15:23:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 3/6 v2] btrfs: dev add should add its sysfs entry
Message-ID: <20140603132342.GK22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
 <1401766564-7381-4-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401766564-7381-4-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 11:36:01AM +0800, Anand Jain wrote:
> we would need the device links to be created,
> when device is added.
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
