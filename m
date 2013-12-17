Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab3LQOSZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 09:18:25 -0500
Date: Tue, 17 Dec 2013 15:18:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] btrfs-progs: handle error in the
 btrfs_prepare_device
Message-ID: <20131217141824.GN6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52B00D4F.5080403@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1387247616-1574-1-git-send-email-anand.jain@oracle.com>
 <1387247616-1574-3-git-send-email-anand.jain@oracle.com>
 <52B004E1.706@giantdisaster.de>
 <52B00D4F.5080403@oracle.com>

On Tue, Dec 17, 2013 at 04:37:35PM +0800, Anand Jain wrote:
> >>+zero_dev_error:
> >>+	if (ret) {
> >>+		ret < 0 ?
> >>+		fprintf(stderr, "ERROR: failed to zero device start '%s' - %s\n",
> >>+			file, strerror(-ret)) :
> >>+		fprintf(stderr, "ERROR: failed to zero device start '%s' - %d\n",
> >>+			file, ret);
> >
> >This is not funny.
> 
>  hmm. I am not sure what you mean ?

It's rather obfuscated, though it's a valid C. No need to minimize the
source line count but the time to understand them.
