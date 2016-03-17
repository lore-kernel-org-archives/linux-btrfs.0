Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876AbcCQKs7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 06:48:59 -0400
Date: Thu, 17 Mar 2016 11:48:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: remove save_error_info()
Message-ID: <20160317104832.GS21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458182337-3841-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458182337-3841-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 17, 2016 at 10:38:57AM +0800, Anand Jain wrote:
> Actually save_error_info() sets the FS state to error
> and nothing else. Further the word save doesn't induce
> caffeine when compared to the word set in what actually
> it does.
> 
> So to make it better understandable move save_error_info()
> code to its only consumer itself.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
