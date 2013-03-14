Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab3CNWlg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 18:41:36 -0400
Date: Thu, 14 Mar 2013 23:41:34 +0100
From: David Sterba <dsterba@ds.suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print errno string when /dev/btrfs-control
 open fails
Message-ID: <20130314224133.GA16857@ds.suse.cz>
References: <1363231039-7580-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363231039-7580-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 14, 2013 at 11:17:19AM +0800, Anand Jain wrote:
>  		fprintf(stderr, "failed to open /dev/btrfs-control "
> -			"skipping device registration\n");
> +			"%s, skipping device registration\n",
> +			strerror(errno));

I think the common pattern here is that error details follow the
message, like

+			"skipping device registration: %s\n",

I'll fix it here, if you don't mind.

david
