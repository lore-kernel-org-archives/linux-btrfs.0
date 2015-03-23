Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:35148 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbCWUBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 16:01:42 -0400
Received: by yhim52 with SMTP id m52so46245725yhi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 13:01:41 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Mar 2015 14:01:41 -0600
Message-ID: <CAJCQCtSmjNVWZaqKr_NcOnpRbSn8mzfutz5jeTDrk=qAT-Z2Vw@mail.gmail.com>
Subject: kvm bug, guest I/O blk device errors when qcow2 backing file is on Btrfs
From: Chris Murphy <chris@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can't tell if this is a kvm virtio blk device regression, with
cache=none and cache=directsync, or if it's a Btrfs regression.

The summary is that on a host using (Fedora) kernel 3.18.9, 3.19.2, or
any 4.0.0 kernel, with qcow2 on Btrfs, and either cache=none or
directsync, the guest Linux OS experiences many I/O blk device errors.

https://bugzilla.redhat.com/show_bug.cgi?id=1204569

If I put the qcow2 on XFS, the problem doesn't happen.

If I keep the qcow2 on Btrfs, and change the cache= to writeback,
writethrough, or unsafe, the problem doesn't happen.

It happens with either qcow2 compat 0.10 or 1.1. Raw files were not
tested. And block devices other than virtio were not tested.

In the guest, all file systems experience this and complain, some more
than others. Btrfs is most tolerant mainly reporting write errors but
completes an OS installation; ext4 complains a lot but also completes
an OS installation; XFS complains and eventually gives up with a
hardware I/O error and the OS installation fails.

I did this test maybe two years ago and this combination was safe at that time.


-- 
Chris Murphy
