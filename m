Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52583 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbbCaWFO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 18:05:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yd4HP-0000nX-TD
	for linux-btrfs@vger.kernel.org; Wed, 01 Apr 2015 00:05:04 +0200
Received: from host86-128-1-111.range86-128.btcentralplus.com ([86.128.1.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 00:05:03 +0200
Received: from ben by host86-128-1-111.range86-128.btcentralplus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 00:05:03 +0200
To: linux-btrfs@vger.kernel.org
From: Benjamin Hodgetts <ben@xnode.org>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
Date: Tue, 31 Mar 2015 21:24:57 +0000 (UTC)
Message-ID: <loom.20150331T232346-529@post.gmane.org>
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

G. Richard Bellamy <rbellamy <at> pteradigm.com> writes:

> 
> When I upgrade to the 3.19.2 Kernel I get a deadlocked boot:
> INFO: task mount:302 blocked for more than 120 seconds.
> INFO: task btrfs-transacti:329 blocked for more than 120 seconds.
> 
> I have an LTS Kernel at 3.14.35 that also fails to boot with the same 
behavior.
> 
> My 3.18.6 works just fine.
> 
> -rb
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Same issue here. Rebooted after updating to 3.19.2 and now I get the 
"mount blocked" message and can't boot.

