Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53201 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbeAEONv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 09:13:51 -0500
Date: Fri, 5 Jan 2018 15:11:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: optimize move uuid_mutex closer to the
 critical section
Message-ID: <20180105141144.GM3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171215074016.26461-1-anand.jain@oracle.com>
 <20171215074016.26461-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171215074016.26461-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 15, 2017 at 03:40:15PM +0800, Anand Jain wrote:
> Move uuid_mutex closer to the exclusion section.

Looks good, there's really something unrelated inside the critical
section so this could potentially speed up scanning devices.

Reviewed-by: David Sterba <dsterba@suse.com>
