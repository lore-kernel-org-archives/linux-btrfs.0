Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41321 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3COBg7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 21:36:59 -0400
Message-ID: <51427B5F.1070403@oracle.com>
Date: Fri, 15 Mar 2013 09:37:35 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: David Sterba <dsterba@ds.suse.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print errno string when /dev/btrfs-control
 open fails
References: <1363231039-7580-1-git-send-email-anand.jain@oracle.com> <20130314224133.GA16857@ds.suse.cz>
In-Reply-To: <20130314224133.GA16857@ds.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> I think the common pattern here is that error details follow the
> message, like
>
> +			"skipping device registration: %s\n",
>
> I'll fix it here, if you don't mind.

  Pls do. Thanks David.

-Anand
