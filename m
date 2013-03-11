Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3CKR0m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 13:26:42 -0400
Date: Mon, 11 Mar 2013 18:26:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: get better concurrency for snapshot-aware defrag
 work
Message-ID: <20130311172640.GF7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362993658-30147-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362993658-30147-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 05:20:58PM +0800, Liu Bo wrote:
> Using spinning case instead of blocking will result in better concurrency
> overall.

Do you have numbers to support that?

david
