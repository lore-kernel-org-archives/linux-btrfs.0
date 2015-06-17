Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbbFQPdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 11:33:08 -0400
Date: Wed, 17 Jun 2015 17:33:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [RFC PATCH v2 1/2] Btrfs: add noi_version option to disable
 MS_I_VERSION
Message-ID: <20150617153306.GY6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 03:54:31PM +0800, Liu Bo wrote:
> MS_I_VERSION is enabled by default for btrfs, this adds an alternative
> option to toggle it off.

There's an existing generic iversion/noiversion mount option pair, no
need to extra add it to btrfs.
