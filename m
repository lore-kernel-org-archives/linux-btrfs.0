Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPLdj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 07:33:39 -0400
Date: Thu, 16 Oct 2014 13:33:37 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com
Subject: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141016113337.GC22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the core of skinny-metadata feature has been merged in 3.10 (Jun 2013)
and has been reportedly used by many people. No major bugs were reported
lately unless I missed them.

The obvious benefit is reduced metadata consumption at the cost of lost
backward compatibility for pre-3.10 kernels. I believe this is
acceptable to do the change now.

The feature can be turned off at mkfs time by '-O ^skinny-metadata' if
needed.

I'd like to make it default with the 3.17 release of btrfs-progs.
Please let me know if you have objections.
