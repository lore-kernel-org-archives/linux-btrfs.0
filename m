Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:36313 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761443Ab2FEDmy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jun 2012 23:42:54 -0400
Message-ID: <4FCD803A.2070906@csamuel.org>
Date: Tue, 05 Jun 2012 13:42:50 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Recovering a file from a snapshot without duplicating its blocks
 (--reflink across devs?)
References: <20120605030100.GA7572@merlins.org>
In-Reply-To: <20120605030100.GA7572@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/06/12 13:01, Marc MERLIN wrote:

> First I though, I sure would be nice if I could take btrfs to reference
> the same blocks from the snapshot to my current image.
> But, --reflink failed across devices nodes, so I was forced to
> copy/duplicate the blocks (36GB).

Patches for this were posted over a year ago, but it was NAK'd by
Christoph Hellwig.  I don't know if it's got any further since then. :-(

Patch description:

 http://www.spinics.net/lists/linux-btrfs/msg09226.html

NAK:

 http://www.spinics.net/lists/linux-btrfs/msg09229.html

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
