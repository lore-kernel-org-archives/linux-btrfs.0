Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from noc.netops.me ([50.22.23.10]:57187 "EHLO noc.netops.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaDXHN1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 03:13:27 -0400
Message-ID: <5358B996.4060102@aeb.io>
Date: Thu, 24 Apr 2014 00:13:26 -0700
From: Adam Brenner <adam@aeb.io>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Which companies are using Btrfs in production?
References: <20140424011834.GN26949@merlins.org> <20140424011952.GO26949@merlins.org>
In-Reply-To: <20140424011952.GO26949@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/23/2014 06:19 PM, Marc MERLIN wrote:
> Oh while we're at it, are there companies that can say they are using btrfs
> in production?
>
> Marc
>

On the Gluster Listsrv a few brave souls have used it on as a 
distributive filesystem[1]. Here at UCI's HPC Cluster we *might* use it 
on a scratch filesystem ... if we upgrade to a newer kernel....

[1]: http://www.gluster.org/pipermail/gluster-users/2014-April/039896.html

-- 
Adam Brenner <adam@aeb.io>
