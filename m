Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m.nv-systems.net ([176.9.99.115]:44203 "EHLO m.nv-systems.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259AbcFBJcp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 05:32:45 -0400
Received: from [192.168.7.22] (p5DCBC55E.dip0.t-ipconnect.de [93.203.197.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by m.nv-systems.net (Postfix) with ESMTPSA id D0EB42025C39E
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 11:24:43 +0200 (CEST)
Subject: Re: raid5/6 production use status?
To: linux-btrfs@vger.kernel.org
References: <1464819934.6742.71.camel@scientia.net>
From: Gerald Hopf <gerald.hopf@nv-systems.net>
Message-ID: <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
Date: Thu, 2 Jun 2016 11:24:45 +0200
MIME-Version: 1.0
In-Reply-To: <1464819934.6742.71.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Hey.
>
> I've lost a bit track recently and the wiki changelog doesn't seem to
> contain much about how things went on at the RAID5/6 front... so how're
> things going?
>
> Is it already more or less "productively" usable? What's still missing?
Well, you still can't even check for free space.

~ # btrfs fi usage /mnt/data-raid
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
     Device size:                  18.19TiB
     Device allocated:                0.00B
     Device unallocated:           18.19TiB
     Device missing:                  0.00B
     Used:                            0.00B
     Free (estimated):                0.00B      (min: 8.00EiB)

btrfs --version ==> btrfs-progs v4.5.3-70-gc1c27b9
kernel ==> 4.6.0


