Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46969 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932384AbeF1QAV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:00:21 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id A688821C1A
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 12:00:20 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0683E10277
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 12:00:19 -0400 (EDT)
From: Remi Gauvin <remi@georgianit.com>
Subject: [PATCH RFC] btrfs: Do extra device generation check at mount time
To: linux-btrfs@vger.kernel.org
References: <20180628070443.23421-1-wqu@suse.com>
 <20180628143618.dcwakob5jw2ccx4y@angband.pl>
Message-ID: <9f8bf838-85ac-6659-40dd-ba9d9be24d48@georgianit.com>
Date: Thu, 28 Jun 2018 12:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <20180628143618.dcwakob5jw2ccx4y@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-06-28 10:36 AM, Adam Borowski wrote:

> 
> Uhm, that'd be a nasty regression for the regular (no-nodatacow) case. 
> The vast majority of data is fine, and extents that have been written to
> while a device is missing will be either placed elsewhere (if the filesystem
> knew it was degraded) or read one of the copies to notice a wrong checksum
> and automatically recover (if the device was still falsely believed to be
> good at write time).
> 
> We currently don't have selective scrub yet so resyncing such single-copy

That might not be the case. though I don't really know the numbers
myself and repeating this is hearsay:

crc32 is not infallible.  1 in so many billion errors will be undetected
by it.  In the case of a dropped device with write failures, when you
*know* the data supposedly written to the disk is bad, re-synching from
believed good copy (so long as it passes checksum verification, of
course), is the only way to be certain that the data is good.


Otherwise, you can be left with a Schroedinger's bit somewhere,  (It's
not 0 or 1, but both, depending on which device the filesystem is
reading from at the time.)


