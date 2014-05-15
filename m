Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbaEOQ5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 12:57:19 -0400
Date: Thu, 15 May 2014 18:57:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add xxhash
Message-ID: <20140515165717.GQ6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
 <1399460193-1713-5-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399460193-1713-5-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Obviously I can't put that patch into progs integration as it's changing
the default behaviour. You can add #ifdefs if you want.
