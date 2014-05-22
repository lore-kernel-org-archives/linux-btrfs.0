Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39246 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaEVLVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 07:21:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WnR3o-0000vA-8t
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 13:21:20 +0200
Received: from ip4da2a5ae.direct-adsl.nl ([77.162.165.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 13:21:20 +0200
Received: from koen by ip4da2a5ae.direct-adsl.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 13:21:20 +0200
To: linux-btrfs@vger.kernel.org
From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: [PATCH 2/2 v3] btrfs: usage error should not be logged into system
 log
Date: Thu, 22 May 2014 13:21:08 +0200
Message-ID: <llkmj4$9r5$1@ger.gmane.org>
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400755272-22590-1-git-send-email-anand.jain@oracle.com> <1400755272-22590-2-git-send-email-anand.jain@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <1400755272-22590-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Anand Jain schreef op 22-05-14 12:41:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> I have an opinion that system logs /var/log/messages are valuable info to
> investigate the real system issues at the data center. People handling
> data center issues do spend a lot time and efforts analyzing messages 
> files. Having usage error logged into /var/log/messages is something we
> should avoid.

Do you mean 'syslog' when you say '/var/log/messages'? There's no
/var/log/messages on my machines..

regards,

Koen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (Darwin)
Comment: GPGTools - http://gpgtools.org

iD8DBQFTfd2kMkyGM64RGpERAsd6AKCZxfhjjtYWUZLJwS0NnghuCb9lBQCfYye2
L3z3JmZqj9TTb+355MMB6w8=
=SfnW
-----END PGP SIGNATURE-----

