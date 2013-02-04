Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:37111 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3BDNAF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 08:00:05 -0500
Date: Mon, 4 Feb 2013 14:00:01 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Does btrfs adapt to size changes of underlying block device(s)?
Message-ID: <20130204130001.GC27997@mother.jarsat.pl>
References: <687dbd42013568bf82390c86d4661ce4.squirrel@webmail.tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <687dbd42013568bf82390c86d4661ce4.squirrel@webmail.tu-dortmund.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 04, 2013 at 01:37:21PM +0100, Simon Campese wrote:
> Hello,
> 
> I've got a quick question: Does btrfs adapt to size changes of the
> underlying block device(s)?
> 
> My specific situation is as follows: I've got a luks-volume on which I
> want to put btrfs. If this luks-volume grows in the future (i.e. by
> 'cryptsetup resize'), will btrfs automatically (and reliably) "see" this
> and be able to use the additional space?

  Not automatically, you need to invoke btrfs command for that. But 
shrinking and growing works online and is reliable.

   btrfs filesystem resize [devid:][+/-]<newsize>[gkm]|[devid:]max <path>

-- 
Tomasz Torcz                 Morality must always be based on practicality.
xmpp: zdzichubg@chrome.pl                -- Baron Vladimir Harkonnen

