Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:45213 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbbAAB0W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 20:26:22 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 7AA17406B8
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Jan 2015 12:26:21 +1100 (AEDT)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 15620-04 for <linux-btrfs@vger.kernel.org>;
 Thu,  1 Jan 2015 12:26:21 +1100 (AEDT)
Received: from quad.localnet (2001-44b8-41dd-d500-4435-4821-17f6-29f5.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:4435:4821:17f6:29f5])
	by csamuel.org (Postfix) with ESMTPSA id 15FC64036F
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Jan 2015 12:26:21 +1100 (AEDT)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: I need to P. are we almost there yet?
Date: Thu, 01 Jan 2015 12:26:25 +1100
Message-ID: <2740386.L6W23cCsJO@quad>
In-Reply-To: <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com> <54A3633C.3040609@ubuntu.com> <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Dec 2014 09:27:14 AM ashford@whisperpc.com wrote:

> I see this as a CRITICAL design flaw.  The reason for calling it CRITICAL
> is that System Administrators have been trained for >20 years that RAID-10
> can usually handle a dual-disk failure, but the BTRFS implementation has
> effectively ZERO chance of doing so.

I suspect this is a knock-on effect of the fact that (unless this has changed 
recently & IIRC) RAID-1 with btrfs will only mirrors data over two drives, no 
matter how many you add to an array.

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


