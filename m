Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbcCPKSP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 06:18:15 -0400
Date: Wed, 16 Mar 2016 11:17:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 5/5] btrfs: move error handling code together in ctree.h
Message-ID: <20160316101749.GK21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
 <1458117788-840-4-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458117788-840-4-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 04:43:08PM +0800, Anand Jain wrote:
> Looks like we added the incompatible defines in between the error
> handling defines in the file ctree.h. Now group them back.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
