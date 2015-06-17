Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16976 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbbFQPwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 11:52:47 -0400
Date: Wed, 17 Jun 2015 23:52:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [RFC PATCH v2 1/2] Btrfs: add noi_version option to disable
 MS_I_VERSION
Message-ID: <20150617155234.GB7773@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
 <20150617153306.GY6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150617153306.GY6761@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 05:33:06PM +0200, David Sterba wrote:
> On Wed, Jun 17, 2015 at 03:54:31PM +0800, Liu Bo wrote:
> > MS_I_VERSION is enabled by default for btrfs, this adds an alternative
> > option to toggle it off.
> 
> There's an existing generic iversion/noiversion mount option pair, no
> need to extra add it to btrfs.

I know, it doesn't work though.

Thanks,

-liubo
