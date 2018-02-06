Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37925 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752003AbeBFQYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Feb 2018 11:24:39 -0500
Date: Tue, 6 Feb 2018 17:22:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: not a disk error if the bio_add_page fails
Message-ID: <20180206162224.GE31890@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180105024707.26078-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105024707.26078-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 10:47:07AM +0800, Anand Jain wrote:
> bio_add_page() can fail for logical reasons as from the bio_add_page()
> comments:- 'This will only fail if either
> bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.'
> Here as we have just allocated the bio, so both of those failures can't
> occur. So drop the check for fail. Which would also drop write error
> statistics.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
