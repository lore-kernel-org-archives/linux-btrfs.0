Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbcHQLlT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Aug 2016 07:41:19 -0400
Date: Wed, 17 Aug 2016 13:40:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, mfasheh@suse.de
Subject: Re: [PATCH] btrfs: Fix leaking bytes_may_use after hitting EDQUOTA
Message-ID: <20160817114023.GV30795@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160628015729.14624-1-quwenruo@cn.fujitsu.com>
 <3be89416-cb88-34aa-4dc0-34fc6f36ca04@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3be89416-cb88-34aa-4dc0-34fc6f36ca04@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 17, 2016 at 10:46:30AM +0800, Qu Wenruo wrote:
> Hi David,
> 
> I think this patch is forgot for v4.8 merge windows.
> 
> Xfstest btrfs/022 is complaining about the problem if the patch is not 
> applied.

Yeah this should go to 4.8, the patch looks good to me, but I'd
appreciate a review, ccing Mark.
