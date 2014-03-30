Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40184 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaC3AV0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Mar 2014 20:21:26 -0400
Received: from 24-182-54-115.dhcp.crcy.nv.charter.com ([24.182.54.115]:40213 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WU3V8-0001TM-9q by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 29 Mar 2014 17:21:26 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WU3V5-0002KA-Sq
	for linux-btrfs@vger.kernel.org; Sat, 29 Mar 2014 17:21:23 -0700
Date: Sat, 29 Mar 2014 17:21:23 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: determining snapshot size
Message-ID: <20140330002123.GP22552@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a look at
http://bj0z.wordpress.com/2011/04/27/determining-snapshot-size-in-btrfs/#comment-35
but it's quite old and does not work anymore since userland became
incompatible with it.

Has anyone seen something newer or have a newer fixed version of this?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
