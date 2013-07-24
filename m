Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44046 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3GXKPH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jul 2013 06:15:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V1w64-0004m8-19
	for linux-btrfs@vger.kernel.org; Wed, 24 Jul 2013 12:15:04 +0200
Received: from pool-108-7-96-134.bstnma.fios.verizon.net ([108.7.96.134])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jul 2013 12:15:04 +0200
Received: from ndokos by pool-108-7-96-134.bstnma.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jul 2013 12:15:04 +0200
To: linux-btrfs@vger.kernel.org
From: Nick Dokos <ndokos@gmail.com>
Subject: Re: technical explanation of btrfs internals?
Date: Wed, 24 Jul 2013 06:05:36 -0400
Message-ID: <8761w0ff2n.fsf@gmail.com>
References: <2485093.JB7ILPBAM9@t61>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Koch <thomas@koch.ro> writes:

> Hi,
>
> when I learned Git I made the experience that it was actually a lot easier to 
> understand Git by learning the internals: blobs, trees, commits, tags and how 
> they are connected, e.g. 
> http://eagain.net/articles/git-for-computer-scientists/
>
> Is there a document or presentation out there that takes this approach to 
> explain btrfs?
>

The btrfs wiki contains some documentation like this, e.g.

  https://btrfs.wiki.kernel.org/index.php/Code_documentation

-- 
Nick

