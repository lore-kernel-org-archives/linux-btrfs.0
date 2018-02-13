Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41579 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965091AbeBMRGZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 12:06:25 -0500
Date: Tue, 13 Feb 2018 18:04:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: log, when replace, is canceled by the user
Message-ID: <20180213170408.GA3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180212153658.19631-1-anand.jain@oracle.com>
 <20180213035343.18128-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180213035343.18128-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 11:53:43AM +0800, Anand Jain wrote:
> For forensic investigations of issues, we would want to know
> if and when the user cancels the replace.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've updated the changelog a bit.
