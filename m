Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57834 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab3LaRCW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Dec 2013 12:02:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vy2hw-0005eE-K1
	for linux-btrfs@vger.kernel.org; Tue, 31 Dec 2013 18:02:20 +0100
Received: from c-24-17-202-252.hsd1.wa.comcast.net ([24.17.202.252])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 18:02:20 +0100
Received: from eternaleye by c-24-17-202-252.hsd1.wa.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 18:02:20 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: question regarding caching
Date: Tue, 31 Dec 2013 09:02:09 -0800
Message-ID: <l9uta5$hou$1@ger.gmane.org>
References: <CAEx9m44ZiJLqTO1_G_rVfn+csD7_pOguEdiAjsvr3uPzna+mFA@mail.gmail.com> <6fp9pa-9un.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow wrote:

> Aastha Mehta <aasthakm@gmail.com> schrieb:
> 
>> Rather than a local disk, I have a remote device to which my IO
>> requests are sent and from which the data is fetched. I need certain
>> data to be fetched from the remote device after a remount. But somehow
>> I do not see any request appearing at the device. I even tried to do
>> drop_caches after remounting the file system, but that does not seem
>> to help.
> 
> Maybe you or your distribution deployed cachefilesd and uses it for the
> remote fs?

The FS-Cache infrastructure only applies to filesystems which opt in to 
using it (NFS, recent work on Ceph, etc), so mounting btrfs over a remote 
block device wouldn't use it at all.

