Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lulu.zabbo.net ([69.168.54.52]:42830 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759893Ab2FUTdJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 15:33:09 -0400
Received: from [192.168.242.10] (50-193-208-193-static.hfc.comcastbusiness.net [50.193.208.193])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by lulu.zabbo.net (Postfix) with ESMTPSA id 70F2E2216DB
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2012 12:33:08 -0700 (PDT)
Message-ID: <4FE376F3.5030609@zabbo.net>
Date: Thu, 21 Jun 2012 12:33:07 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: flush delayed inodes if we're short on space
References: <1340304875-8111-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1340304875-8111-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> +	case FLUSH_DELAYED_ITEMS_NR:
> +	case FLUSH_DELAYED_ITEMS:
> +		nr = (*state == FLUSH_DELAYED_ITEMS_NR) ? 10 : -1;

This 10 seemed awfully magical so I read a bit more.

It appears to be an attempt to pop back up into reserve_metadata_bytes()
to see if the caller has been satisfied before continuing on to apply
all the delayed items.

The magic number seems awfully clumsy.  It'll either do too much work or
will blow through all the delayed items, depending on the load.  Is it
too hard to have btrfs_run_delayed_items() check for the callers
reservation and return if there's a chance that it'll be satisfied?

Am I missing something?  Over-thinking a rare path as the initial steps
will tend to free up space most of the time?

- z
