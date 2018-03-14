Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751758AbeCNPkm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:40:42 -0400
Date: Wed, 14 Mar 2018 16:38:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: check for SB checksum when scanned
Message-ID: <20180314153804.GK32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180313150637.3913-1-anand.jain@oracle.com>
 <8951fcb0-aadd-6a10-50f7-eac44ff41438@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8951fcb0-aadd-6a10-50f7-eac44ff41438@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2018 at 11:20:41AM +0200, Nikolay Borisov wrote:
> 
> 
> On 13.03.2018 17:06, Anand Jain wrote:
> > We aren't checking the SB csum when the device scanned,
> > instead we do that when mounting the device, and if the
> > csum fails we fail the mount. How if we check the csum
> > when the device is scanned, I can't see any reason for
> > why not? any idea?
> 
> So what problems does this solve?

Devices with partially corrupted superblock with a valid UUID will be
added to list of scanned devices. This will be rejected at mount time so
it's not a problem in the end but there are structures tracking the
device, so we'd get rid of that early.
