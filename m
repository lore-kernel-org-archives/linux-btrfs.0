Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43698 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbaICVda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 17:33:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by gateway2.nyi.internal (Postfix) with ESMTP id ABAF32083B
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Sep 2014 17:33:29 -0400 (EDT)
Date: Wed, 3 Sep 2014 14:33:28 -0700
From: Greg KH <greg@kroah.com>
To: Chris Mason <clm@fb.com>
Cc: stable@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs stable updates for v3.16
Message-ID: <20140903213328.GB20589@kroah.com>
References: <54077F27.1040603@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54077F27.1040603@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 03, 2014 at 04:50:47PM -0400, Chris Mason wrote:
> Hi everyone,
> 
> For 3.16, please pull these into stable, I've cherry picked and tested
> them here.  For 3.15 and earlier there are a few conflicts, so I'll make
> a git tree with things to pull.
> 
> 8d875f95da43c6a8f18f77869f2ef26e9594fecc v3.15+
> 38c1c2e44bacb37efd68b90b3f70386a8ee370ee v3.11+
> f6dc45c7a93a011dff6eb9b2ffda59c390c7705a v3.15+
> 9e0af23764344f7f1b68e4eefbe7dc865018b63d v3.15+

Now applied to the trees I manage.

thanks,

greg k-h
