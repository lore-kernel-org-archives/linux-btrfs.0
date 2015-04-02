Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43686 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbbDBRbu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 13:31:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ydiy3-0007i8-Qc
	for linux-btrfs@vger.kernel.org; Thu, 02 Apr 2015 19:31:47 +0200
Received: from p4ff588ee.dip0.t-ipconnect.de ([79.245.136.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Apr 2015 19:31:47 +0200
Received: from holger.hoffstaette by p4ff588ee.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Apr 2015 19:31:47 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH v2] Btrfs: fix range cloning when same inode used as
 source and destination
Date: Thu, 2 Apr 2015 17:31:42 +0000 (UTC)
Message-ID: <pan.2015.04.02.17.31.42@googlemail.com>
References: <1427810206-23103-1-git-send-email-fdmanana@suse.com>
	<1427995511-13028-1-git-send-email-fdmanana@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Thu, 02 Apr 2015 18:25:11 +0100, Filipe Manana wrote:

> V2: Fixed a warning about potentially uninitialized variable. David
>     got this warning on a 4.5.1 gcc, but I didn't on a 4.9.2 gcc
>     however.

I was *just* about to post this warning, since I saw it only a minute ago!

I assume you mean:

fs/btrfs/ioctl.c: In function 'btrfs_clone':
fs/btrfs/ioctl.c:3531:14: warning: 'next_key_min_offset' may be used uninitialized in this function [-Wmaybe-uninitialized]
   key.offset = next_key_min_offset;
              ^

..and this is with 4.9.2 here.

Anyway..thanks for being faster :)

Holger

