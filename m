Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55959 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaAIBcW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 20:32:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W14Tt-0003ju-9e
	for linux-btrfs@vger.kernel.org; Thu, 09 Jan 2014 02:32:21 +0100
Received: from 78-32-127-104.static.enta.net ([78.32.127.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 02:32:21 +0100
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 02:32:21 +0100
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: REQ: btrfs list <subvols only> option
Date: Thu, 9 Jan 2014 01:31:53 +0000 (UTC)
Message-ID: <loom.20140109T020430-693@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello 

(Using btrfs userland 3.12)

I have my fs set up (below) I borrowed the Ubuntu scheme.

<FS_TREE>/@/
<FS_TREE>/@/etc
<FS_TREE>/@/var
..

get-default is 5 i.e. <FS_TREE>

AFAICT, perhaps I'm missing the obvious, getting the list of subvolumes only
(no snapshots) is no longer trivial? 

# btrfs  sub list /@
ERROR: can't access '/@'
# btrfs  sub list /@
ERROR: can't access '/@'
# btrfs  sub list /@/
ERROR: can't access '/@/'
# btrfs  sub list @/
ERROR: can't access '@/'
# btrfs  sub list @

I know I'm going to be embarrassed at the answer, but go ahead bite me!

Thank you!







