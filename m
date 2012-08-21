Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52892 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab2HUTLp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 15:11:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1T3trc-0005rf-M5
	for linux-btrfs@vger.kernel.org; Tue, 21 Aug 2012 21:11:44 +0200
Received: from xpc1.ast.cam.ac.uk ([131.111.68.219])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2012 21:11:44 +0200
Received: from jeremy by xpc1.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2012 21:11:44 +0200
To: linux-btrfs@vger.kernel.org
From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: btrfs and mdadm raid 6
Date: Tue, 21 Aug 2012 20:11:34 +0100
Message-ID: <k10mh6$6ja$1@ger.gmane.org>
References: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Curtis Jones wrote:

> 1. is btrfs-convert on /dev/md0
> stable/reliable/tested/not-a-stupid-thing-to-do? 2. based on the reading
> I've done, resizing btrfs is supported. can you confirm? 3. there aren't
> any known compatibility or other issues with running btrfs on top of mdadm
> (raid 6) 4. any other caveats I might want to consider?

We've been running btrfs on mdadm for a year or so with no problems (it was 
a fresh file system, though).

Jeremy


