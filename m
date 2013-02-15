Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:20962 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932324Ab3BOEDN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 23:03:13 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.02.1302150455570.8810@shack.dolda2000.com>
Date: Thu, 14 Feb 2013 21:03:11 -0700
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-Id: <3035DD07-301C-4781-8C6F-3B84DDF65143@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com> <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com> <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com> <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com> <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com> <20130214085925.GD28997@carfax.org.uk> <19ABBC76-F774-4225-87A4-73A4D546F53F@colorremedies.com> <alpine.DEB.2.02.1302150447540.8810@shack.dolda2000.com> <0716DBBF-5B83-4211-A038-81C84621FCD5@colorremedies.com> <alpine.DEB.2.02.1302150455570.8810@shack.dolda2000.com>
To: Fredrik Tolf <fredrik@dolda2000.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 14, 2013, at 8:56 PM, Fredrik Tolf <fredrik@dolda2000.com> wrote:

> 
> As you could see from the source code I quoted, the message was, in fact, not prepended with "btrfs: ".

Yep. That's why I'm not so far convinced it's btrfs induced. But clearly btrfs is adversely impacted, and tentatively I'm unsure if the resulting behavior is reasonable.

Chris Murphy