Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55344 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbeHJNPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 09:15:31 -0400
Date: Fri, 10 Aug 2018 12:46:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: assert for num_devices below 0
Message-ID: <20180810104603.GZ3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180810055321.19730-1-anand.jain@oracle.com>
 <20180810055321.19730-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180810055321.19730-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 01:53:20PM +0800, Anand Jain wrote:
> In preparation to add helper function to deduce the num_devices with
> replace running, use assert instead of bug_on and warn_on.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Ok for the updated condition as it's going to be used in the new helper.

Reviewed-by: David Sterba <dsterba@suse.com>
