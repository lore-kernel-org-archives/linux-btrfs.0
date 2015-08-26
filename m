Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:55213 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbbHZTYr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 15:24:47 -0400
Received: from smtp22.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp22.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 7D754380332
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 15:24:46 -0400 (EDT)
Received: from smtp22.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp22.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 79741380346
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 15:24:46 -0400 (EDT)
Received: from app46.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp22.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 6F5F8380339
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 15:24:46 -0400 (EDT)
Received: from up4.tv (localhost.localdomain [127.0.0.1])
	by app46.wa-webapps.iad3a (Postfix) with ESMTP id 5E0C880071
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 15:24:46 -0400 (EDT)
Date: Wed, 26 Aug 2015 15:24:46 -0400 (EDT)
Subject: Re: Response to Bcachefs Claims
From: "Vincent Olivier" <vincent@up4.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
In-Reply-To: <pan$ac59$d5b01668$cfc6f266$3accc55c@cox.net>
References: <1440516154.040713246@apps.rackspace.com>
 <pan$ac59$d5b01668$cfc6f266$3accc55c@cox.net>
Message-ID: <1440617086.383124909@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm still parsing through the multi-device advices. Will be back on this when I'm done. And I'll probably switch distro to Archlinux which seems the way to go if one is using cutting-edge kernel features like Btrfs.

As for the work on "Gotchas/Known Issues" on the Btrfs wiki, I also think that the best way is to start with the Gotchas page and put a more prominent link for it on the home page.

I would restructure the Gotchas page in the following ways :

* Add the mention "Known Issues" close to the title;

* Only keep current issues/gotchas (current stable kernel, current userspace utilities release), archive every other on a separate page;

* Group by smallest feature encompassing the issue : multi-device, quotas, subvolumes, compression, conversion from extX, interactions with other things like LVM, MD, encryption, etc.;

* Something that is "new" and not as thoroughly tested as other features should be listed there as well (I think) until there is a consensus (to be defined) on it being reliable enough to be taken out of the list. Or maybe that should go on another page ?

* Provide links to HOWTOs or best practices for the features discussed (multi-device GOTCHAS should link to multi-device HOWTO).

I will be thinking about it more before doing anything and still welcoming ideas.

Thanks !

Vincent

