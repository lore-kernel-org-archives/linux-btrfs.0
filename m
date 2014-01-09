Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36008 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaAIEGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 23:06:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W16t1-0001yq-D3
	for linux-btrfs@vger.kernel.org; Thu, 09 Jan 2014 05:06:27 +0100
Received: from 78-32-127-104.static.enta.net ([78.32.127.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 05:06:27 +0100
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 05:06:27 +0100
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: Re: REQ: btrfs list <subvols only> option
Date: Thu, 9 Jan 2014 04:06:05 +0000 (UTC)
Message-ID: <loom.20140109T045506-475@post.gmane.org>
References: <loom.20140109T020430-693@post.gmane.org> <38A0596B-F366-453C-ABC2-D4FB25637403@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists <at> colorremedies.com> writes:

> Specify the mount point for the Btrfs file system and it will list all
subvols on that file system.
> 
> Chris Murphy--

Thank you Chris.

When I do that on my version of the 3.12 userland:
# btrfs  sub list / -o
returns nothing (with no error), which I wasn't quite expecting because
there *are* other snapshots and subvols below '/'

AND

# btrfs  sub list / -s
correctly lists the snapshots only.

I don't understand, what or if, I'm doing something wrong.
Thank you in advance.



