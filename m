Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:56722
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbdFBDRl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 23:17:41 -0400
Date: Fri, 2 Jun 2017 08:46:28 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170602031628.GA4098@giis.co.in>
References: <20170513125632.GA10846@giis.co.in>
 <b9f29fde-1e8a-d481-971a-b1951bf9b2a8@cn.fujitsu.com>
 <20170515083653.GA5902@giis.co.in>
 <20170530172006.GY14523@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170530172006.GY14523@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> I think we should use the 64bit types just to be safe.
> 
Dave, Okay made those changes and new patch sent.

>If we need to modify tons of things, then please split such modification to
>different patches.

Qu, Seems like only minor changes needed, so used a single patch.

Cheers.
Lakshmipathi.G

