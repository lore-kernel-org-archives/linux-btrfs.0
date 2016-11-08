Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60342 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751670AbcKHXRI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Nov 2016 18:17:08 -0500
Message-Id: <1478647027.2754208.781741465.2CAFC1A9@webmail.messagingengine.com>
From: Ian Kelling <ian@iankelling.org>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Could receive allow updating an existing subvolume?
Date: Tue, 08 Nov 2016 15:17:07 -0800
References: <1478645336.2739242.781712345.6ADE1927@webmail.messagingengine.com>
 <20161108230057.GQ16645@carfax.org.uk>
 <1478646934.2753701.781728689.373545C7@webmail.messagingengine.com>
In-Reply-To: <1478646934.2753701.781728689.373545C7@webmail.messagingengine.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Nov 8, 2016, at 03:15 PM, Ian Kelling wrote:
> On Tue, Nov 8, 2016, at 03:00 PM, Hugo Mills wrote:
> > 
> >    If the sender sends an incremental stream, that assumes an *exact*
> > subvol state on the receiving side. If the subvol on the receiving
> > side is modified, then the receive can fail.
> 
> No. The reading program never needs to have access to rw files if it's
> reading from a read-only mountpoint while the subvolume is rw and
> mounted as such elsewhere. And a reading program does not magically risk
> writes.

Quoted text was accidentally duplicated, ignore it.
