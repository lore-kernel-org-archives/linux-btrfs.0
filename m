Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:42618
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751661AbdFINDv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Jun 2017 09:03:51 -0400
Date: Fri, 9 Jun 2017 18:32:35 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba <dsterba@suse.cz>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-convert: whats minimum free space requirement?
Message-ID: <20170609130235.GA21971@giis.co.in>
References: <20170609051914.GA3788@giis.co.in>
 <6588ee10-82fe-56aa-3079-955d97a674fd@cn.fujitsu.com>
 <20170609072816.GA7920@giis.co.in>
 <bda5cebd-0683-53f9-6edb-b7f3093b1ed9@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bda5cebd-0683-53f9-6edb-b7f3093b1ed9@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 09, 2017 at 03:38:31PM +0800, Qu Wenruo wrote:
> >I was thinking about adding a free-space check (based on total blocks/free block
> >stat from source superblock) before btrfs-convert begins, looks like its more
> >complex than i thought.
> 
> BTW, it's already done, since it's complex, btrfs-convert will try to
> calculate it early on, so even it fails to find the needed space, it will
> not screw up the old fs.
> 
> Thanks,
> Qu
> >

oh, I didn't realize that, thanks. Will test/try with little free space and check the
returning error messages. 

Cheers.
Lakshmipathi.G
