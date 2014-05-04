Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33874 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaEDFqa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 01:46:30 -0400
Received: from i118-21-136-4.s30.a048.ap.plala.or.jp ([118.21.136.4]:50772 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WgpFs-0000bb-TE by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 22:46:30 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wgkfq-0005II-DJ
	for linux-btrfs@vger.kernel.org; Sat, 03 May 2014 17:52:58 -0700
Date: Sat, 3 May 2014 17:52:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: How does Suse do live filesystem revert with btrfs?
Message-ID: <20140504005257.GF9061@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(more questions I'm asking myself while writing my talk slides)

I know Suse uses btrfs to roll back filesystem changes.

So I understand how you can take a snapshot before making a change, but
not how you revert to that snapshot without rebooting or using rsync,

How do you do a pivot-root like mountpoint swap to an older snapshot,
especially if you have filehandles opened on the current snapshot?

Is that what Suse manages, or are they doing something simpler?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
