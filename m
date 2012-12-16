Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-server.com ([216.13.78.11]:59612 "EHLO smtp-server.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2LPQQw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Dec 2012 11:16:52 -0500
Received: from [192.168.1.104] (dynamic-adsl-78-13-211-5.clienti.tiscali.it [78.13.211.5])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client did not present a certificate)
	by smtp-server.com (Postfix) with ESMTP id 331D617BA05
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Dec 2012 16:16:48 +0000 (UTC)
Message-ID: <50CDF3ED.8060601@libero.it>
Date: Sun, 16 Dec 2012 17:16:45 +0100
From: Claudio Carbone <erupter@libero.it>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: unmountable partition and live distro (no space left)
References: <50CDCFD1.5000304@libero.it>
In-Reply-To: <50CDCFD1.5000304@libero.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'v been told this is missing relevant details.
The original kernel version was 3.2.0-something (standard Ubuntu 12.04 LTS).
I've since upgraded to 3.7 but this has made no difference.
Right now I don't have the dmesg, I'll post it later.

Currently I've been able to mount the partition with btrfs-restore and 
am trying to rsync it on another ext4 volume.

Claudio



On 16/12/12 14:42, Claudio Carbone wrote:
> Hello all.
>
> My system failed and I thought of trying btrfs.
> After repartitioning and installing, nothing booted and my (btrfs 
> formatted) home partition is unmountable (parent transid).
> I discovered I can mount the partition with btrfs-restore but, since 
> I'm running off of a live usb Ubuntu, mounting fails at some point due 
> to lack of space.
> So is there a way I can mount the partition on a live distro to 
> recover what is recoverable?
>
> Thank you
> Claudio
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

