Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaHTO3Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 10:29:16 -0400
Date: Wed, 20 Aug 2014 16:29:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/8 v2] btrfs: rename total_bytes to avoid confusion
Message-ID: <20140820142914.GH1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1407911066-5363-8-git-send-email-anand.jain@oracle.com>
 <1408503257-29568-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1408503257-29568-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 20, 2014 at 10:54:17AM +0800, Anand Jain wrote:
> we are assigning number_devices to the total_bytes,
> that's very confusing for a moment
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Thanks.

Reviewed-by: David Sterba <dsterba@suse.cz>
