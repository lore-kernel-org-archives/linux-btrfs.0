Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:57388
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdEBP3s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 11:29:48 -0400
Date: Tue, 2 May 2017 20:58:41 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: dsterba@suse.cz, quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170502152840.GA3719@giis.co.in>
References: <20170427100534.GA10404@giis.co.in>
 <20170502150601.GK23260@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502150601.GK23260@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 05:06:01PM +0200, David Sterba wrote:
> On Thu, Apr 27, 2017 at 03:35:34PM +0530, Lakshmipathi.G wrote:
> > Bug: Fail to convert 22TB EXT4 to BTRFS
> > https://bugzilla.kernel.org/show_bug.cgi?id=194795
> 
> Thanks for working on the bug, the proposed fix looks good to me judging
> by the use of extended API. This would need a test though. I'm trying
> this on a sparse file, 3TB occupies 50G and is slow to create.
> Conversion works and hasn't finished yet, so this is not suitable for
> tests run by default.
> 
> Please write a more detailed changelog, a reference to bugzilla is not
> really sufficient.

Sure, will send a patch with better commit description about the bug and
proposed fix. 

Cheers.
Lakshmipathi.G
