Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55036 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbbFZRMu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 13:12:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z8XBH-0008Gz-SG
	for linux-btrfs@vger.kernel.org; Fri, 26 Jun 2015 19:12:47 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 19:12:47 +0200
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 19:12:47 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during
 commit
Date: Fri, 26 Jun 2015 19:12:37 +0200
Message-ID: <mmk165$vqh$1@ger.gmane.org>
References: <1428954759-1304912-1-git-send-email-clm@fb.com> <mh8h3f$l3u$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
In-Reply-To: <mh8h3f$l3u$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Testing the patch took much longer than I anticipated due to pre-4.1-kernels
being "too risky" for use on our servers, but now it's done and I can say:

This patch, as integrated in linux-4.1, has successfully removed the lags.

Thanks!

Regards,

Lutz Vieweg


On 04/22/2015 06:09 PM, Lutz Vieweg wrote:
> On 04/13/2015 09:52 PM, Chris Mason wrote:
>> Large filesystems with lots of block groups can suffer long stalls during
>> commit while we create and send down all of the block group caches.  The
>> more blocks groups dirtied in a transaction, the longer these stalls can be.
>> Some workloads average 10 seconds per commit, but see peak times much higher.
>
> Since we see this problem very frequently on some shared development servers,
> I will try to install this ASAP.
>
> Meanwhile, can anybody already tell success stories about successfully removing
> lags by this patch?
>
> Regards,
>
> Lutz Vieweg
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

