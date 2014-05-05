Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58746 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaEFSVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 14:21:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhjeX-0006F1-2r
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 19:59:41 +0200
Received: from apersaud.dhcp.lbl.gov ([128.3.5.177])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 19:59:41 +0200
Received: from apersaud by apersaud.dhcp.lbl.gov with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 19:59:41 +0200
To: linux-btrfs@vger.kernel.org
From: Arun Persaud <apersaud@lbl.gov>
Subject: Re: error 2001, no inode item
Date: Mon, 05 May 2014 15:22:17 -0700
Message-ID: <lk92uq$j8n$1@ger.gmane.org>
References: <53433170.5030806@lbl.gov> <pan$5202e$e473aa9d$bec69d4b$f69d4a7c@cox.net> <li19og$m51$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <li19og$m51$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

tried with a newer version of btrfs, but still getting the same error.

checking extents
checking free space cache
checking fs roots
root 5 inode 5769204 errors 2001, no inode item, link count wrong
        unresolved ref dir 5783881 index 3 namelen 38 name
61bd2ed1fba8bc8d2f12766c7e4b3dafff6350 filetype 1 error 4, no inode ref
root 5 inode 5899187 errors 2001, no inode item, link count wrong
        unresolved ref dir 5906761 index 3 namelen 38 name
61bd2ed1fba8bc8d2f12766c7e4b3dafff6350 filetype 1 error 0
Checking filesystem on /dev/sda4
UUID: 98190f1e-426f-433d-8335-1216b9a63d16
found 28521431809 bytes used err is 1
total csum bytes: 124070732
total tree bytes: 722415616
total fs tree bytes: 552411136
total extent tree bytes: 32673792
btree space waste bytes: 171189111
file data blocks allocated: 188149448704
 referenced 126695161856
Btrfs v3.14.1+20140502

# uname -a
Linux apersaud 3.14.2-25.g1474ea5-desktop #1 SMP PREEMPT Sun Apr 27
14:35:22 UTC 2014 (1474ea5) x86_64 x86_64 x86_64 GNU/Linux

Any idea how I can fix the missing inode problem?

Arun

