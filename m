Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964815AbaFTJxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 05:53:21 -0400
Date: Fri, 20 Jun 2014 11:53:18 +0200
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org,
        jeffm@suse.com, dsterba@suse.cz
Subject: Re: [PATCH 0/6 v2] update sysfs per btrfs device operations
Message-ID: <20140620095318.GA1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

any reason why the patches 1-5 were not added to 3.16 queue?

On Tue, Jun 03, 2014 at 11:35:58AM +0800, Anand Jain wrote:
>   btrfs: rename add_device_membership to btrfs_kobj_add_device
>   btrfs: dev delete should remove sysfs entry
>   btrfs: dev add should add its sysfs entry
>   btrfs: dev replace should replace the sysfs entry
>   btrfs: create sprout should rename fsid on the sysfs as well

The last one was an RFC and independent (I'm going to answer Anand's
comments later)

>   btrfs: revamp /sys/fs/btrfs/<fsid>/devices

Thanks.
