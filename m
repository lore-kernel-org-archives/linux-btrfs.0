Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:52192
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751469AbdAPQg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 11:36:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 16 Jan 2017 09:35:52 -0700
From: lakshmipathi.g@giis.co.in
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btfs-progs: fsck-tests: corrupt nlink value test
In-Reply-To: <9592e847-74a9-d530-96a1-b7b8888975e3@cn.fujitsu.com>
References: <20170107231955.GA24631@fedori>
 <c9e21f30-2231-94cd-09ed-8422951e7b69@cn.fujitsu.com>
 <fdc7f38883f4333cad73b7a92a1ba00a@giis.co.in>
 <77e26cd7-0390-d02e-3dda-7107a2c68e7d@cn.fujitsu.com>
 <f5ef3a5bec7fccbd06559eda6a7cf59a@giis.co.in>
 <9592e847-74a9-d530-96a1-b7b8888975e3@cn.fujitsu.com>
Message-ID: <43f607d52e2ba14633096022575bb5de@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs-corrupt-block is in bad shape, then corruption scripts around 
them won't help in long term.

Yes, documentation for btrfs-corrupt-block needs improvement.  imo, 
re-arranged priority will be like : (5), (1)/(3) then (4).  Agree that 
some corner cases, having static image is best option, i think the 
corruption test-case needs to be mixture of both static-images and 
scripts.

For the time being, I'll create static-images to cover corruption cases. 
thanks.

Cheers,
Lakshmipathi.G
