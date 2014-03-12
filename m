Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40607 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595AbaCLIAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 04:00:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WNe56-0004Ca-4I
	for linux-btrfs@vger.kernel.org; Wed, 12 Mar 2014 09:00:04 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 09:00:04 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 09:00:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2] Btrfs: return EPERM when deleting a default
 subvolume
Date: Wed, 12 Mar 2014 07:58:08 +0000 (UTC)
Message-ID: <pan$71e16$d5576176$5a9b4320$313b7a7f@cox.net>
References: <1394562258-17024-1-git-send-email-guangyu.sun@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Guangyu Sun posted on Tue, 11 Mar 2014 11:24:18 -0700 as excerpted:

> The error message does not make sense to me: [snip]

The subject says v2, which explains why I was getting deja vu reading the 
description, but there's no listing of what changed from v1, as is 
customary when a revision is posted.  See pretty much any other patch 
with multiple revisions.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

