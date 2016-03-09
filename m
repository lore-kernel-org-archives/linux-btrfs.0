Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbcCIMpq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 07:45:46 -0500
Date: Wed, 9 Mar 2016 13:45:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, chandan@linux.vnet.ibm.com
Subject: Re: [PATCH] btrfs-progs: Replace hardcoded PAGE_CACHE_SIZE with
 getpagesize().
Message-ID: <20160309124524.GB738@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457526133-28575-1-git-send-email-xufeifei@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457526133-28575-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2016 at 08:22:13PM +0800, Feifei Xu wrote:
> PAGE_CACHE_SIZE is hardcoded to 4K in cmds-restore.c. It makes lzo
> decompress fail on ppc64. Fix this through replacing hardcoded 4K
> with getpagesize().

You're right that the hardcoded value is a bug, but the correct value is
the sector size. Ie. when the system is 4k page size and filesystem is
eg. from ppc64.
