Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753380AbdJMMaN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 08:30:13 -0400
Date: Fri, 13 Oct 2017 14:28:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] btrfs: add_missing_dev() should return the actual
 error
Message-ID: <20171013122827.GL3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171009030746.16680-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171009030746.16680-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 09, 2017 at 11:07:43AM +0800, Anand Jain wrote:
> add_missing_dev() can return device pointer so that IS_ERR/
> PTR_ERR can be used to check for the actual error occurred
> in the function.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---

1-4 added, with some tweaks. Thanks.
