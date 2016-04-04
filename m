Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44940 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbcDDAAx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Apr 2016 20:00:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amrwn-0003QC-RH
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 02:00:49 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 02:00:49 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 02:00:49 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH 00/13 v3] Introduce device state 'failed', Hot spare and
 Auto replace
Date: Mon, 4 Apr 2016 02:00:43 +0200
Message-ID: <20160404020043.47ad35bf@jupiter.sol.kaishome.de>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat,  2 Apr 2016 09:30:38 +0800
schrieb Anand Jain <anand.jain@oracle.com>:

> Auto replace:
>  Replace happens automatically, that is when there is any write
>  failed or flush failed, the device will be marked as failed, which
>  will stop any further IO attempt to that device. And in the next
>  commit cycle the auto replace will pick the spare device to
>  replace the failed device. And so the btrfs volume is back to a
>  healthy state.

Does this also implement "copy-back" - thus, it returns the hot-spare
device to global hot-spares when the failed device has been replaced?

Traditionally, the wording "hot spare" implies that the storage
system runs a copy-back operation when the failing device has been
replaced. The "hot spare" device then returns to its original "hot
spare" function: sitting and waiting to jump in place...

This also helps to keep your drives order in your storage enclosure.
Without copy-back, the association between member drive and storage
enclosure would fluctuate over time and you'd have to constantly update
documentation. Add many identical systems, and you have a lot of
different system configurations over time with individual
documentation. This becomes confusing at best, and turns out
dangerously probably (when pulling the wrong drive due to confusion).

Otherwise, I find "hot spare" misleading and it should be renamed.

-- 
Regards,
Kai

Replies to list-only preferred.

