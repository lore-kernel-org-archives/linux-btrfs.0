Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46673 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751690AbeBSPJw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 10:09:52 -0500
Date: Mon, 19 Feb 2018 16:07:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: cow_file_range() num_bytes and disk_num_bytes
 are same
Message-ID: <20180219150734.GI10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180215042938.18963-1-anand.jain@oracle.com>
 <fb33c4c3-e9a6-5a16-275a-353d623720b1@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb33c4c3-e9a6-5a16-275a-353d623720b1@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 10:38:00AM +0200, Nikolay Borisov wrote:
> 
> 
> On 15.02.2018 06:29, Anand Jain wrote:
> > This patch deletes local variable disk_num_bytes as its value
> > is same as num_bytes in the function cow_file_range().
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Added to next, thanks.
