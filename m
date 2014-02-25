Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:64496 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBYH3h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 02:29:37 -0500
Received: by mail-vc0-f176.google.com with SMTP id la4so6742284vcb.7
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 23:29:36 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 25 Feb 2014 02:29:36 -0500
Message-ID: <CAAdM645za0M6fze7P430Y0smfaw7_i06m61bvwE6ghUrLV-+8w@mail.gmail.com>
Subject: Limits of BTRFS_IOC_LOGICAL_INO & BTRFS_IOC_INO_PATHS
From: Marios Titas <redneb8888@gmail.com>
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was experimenting with the BTRFS_IOC_LOGICAL_INO &
BTRFS_IOC_INO_PATHS ioctls and noticed that there are some limits in
the kernel that limit the number or results they return. For example,
for BTRFS_IOC_LOGICAL_INO, the structure that will hold the results
can be up to 65536 bytes. Are there any plans to provide an
alternative way to access that information without the aforementioned
limits? This would be useful, for example, for userspace dedup
applications.
