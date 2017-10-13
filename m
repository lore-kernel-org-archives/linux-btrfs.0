Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753258AbdJMMSg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 08:18:36 -0400
Date: Fri, 13 Oct 2017 14:16:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs: fix EIO misuse to report missing degraded
 option
Message-ID: <20171013121650.GK3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171009030746.16680-1-anand.jain@oracle.com>
 <20171009030746.16680-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171009030746.16680-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 09, 2017 at 11:07:44AM +0800, Anand Jain wrote:
> EIO is only for the IO failure to the device, avoid it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Updated changelog.

Reviewed-by: David Sterba <dsterba@suse.com>
