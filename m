Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54953 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933841AbbDVQJ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 12:09:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YkxDI-0008Gn-Lk
	for linux-btrfs@vger.kernel.org; Wed, 22 Apr 2015 18:09:24 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 18:09:24 +0200
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 18:09:24 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during
 commit
Date: Wed, 22 Apr 2015 18:09:18 +0200
Message-ID: <mh8h3f$l3u$1@ger.gmane.org>
References: <1428954759-1304912-1-git-send-email-clm@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
In-Reply-To: <1428954759-1304912-1-git-send-email-clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/13/2015 09:52 PM, Chris Mason wrote:
> Large filesystems with lots of block groups can suffer long stalls during
> commit while we create and send down all of the block group caches.  The
> more blocks groups dirtied in a transaction, the longer these stalls can be.
> Some workloads average 10 seconds per commit, but see peak times much higher.

Since we see this problem very frequently on some shared development servers,
I will try to install this ASAP.

Meanwhile, can anybody already tell success stories about successfully removing
lags by this patch?

Regards,

Lutz Vieweg

