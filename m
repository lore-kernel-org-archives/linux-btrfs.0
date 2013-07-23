Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from koch.ro ([88.198.2.104]:56430 "EHLO koch.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3GXIBy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jul 2013 04:01:54 -0400
Received: from gw.ptr-80-238-229-100.customer.ch.netstream.com ([80.238.229.100] helo=t61.localnet)
	by koch.ro with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <thomas@koch.ro>)
	id 1V1tZX-0007uA-MI
	for linux-btrfs@vger.kernel.org; Wed, 24 Jul 2013 09:33:20 +0200
From: Thomas Koch <thomas@koch.ro>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Reply-To: thomas@koch.ro
Subject: technical explanation of btrfs internals?
Date: Tue, 23 Jul 2013 17:28:04 +0200
Message-ID: <2485093.JB7ILPBAM9@t61>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

when I learned Git I made the experience that it was actually a lot easier to 
understand Git by learning the internals: blobs, trees, commits, tags and how 
they are connected, e.g. 
http://eagain.net/articles/git-for-computer-scientists/

Is there a document or presentation out there that takes this approach to 
explain btrfs?

Thank you,

Thomas Koch, http://www.koch.ro
