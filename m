Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:49004
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbdDOLRc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 07:17:32 -0400
Date: Sat, 15 Apr 2017 16:46:20 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: cli-tests: Convert non-raid filesystem to
 raid
Message-ID: <20170415111620.GA8407@giis.co.in>
References: <20170129144455.GA12174@giis.co.in>
 <20170313174750.GR14605@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313174750.GR14605@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 06:47:50PM +0100, David Sterba wrote:
> On Sun, Jan 29, 2017 at 08:14:55PM +0530, Lakshmipathi.G wrote:
> > Simple script to verify non-raid filesystem conversion.
> 
> The cli (command line interface) tests are supposed to cover the common
> usecases from the point of option combinations etc, not really verifying
> the result. It would be good if you add more than just one simple test,
> especially for the balance filters. Adding the helpers to prepare the
> filesystem (number of devices, raid profiles) would be a good start.
> Some code for that is in the mkfs tests, but this belongs to the common
> scripts so we could easily use that.

Ok. I'll try to add helpers to common. So that option like this can
be re-used easily.

Cheers.
Lakshmipathi.G
