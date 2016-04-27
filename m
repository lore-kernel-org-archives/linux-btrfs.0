Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35368 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbcD0US3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 16:18:29 -0400
Received: by mail-lf0-f45.google.com with SMTP id c126so70707936lfb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 13:18:28 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Apr 2016 14:18:27 -0600
Message-ID: <CAHaPQf1sJpO6bDWUQFp=XEEwuV8P8-qY7bT0UgZEdbazUUWNTg@mail.gmail.com>
Subject: ...in the matter of partition size
From: Juan Alberto Cirez <jacirez@rdcsafety.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quick question: Supposed I have n-number of storage pods (physical
servers with n-number of physical hhds). The end deployment will be
btrfs at the brick/block level with a distributed file system on top.
Keeping in mind that my overriding goal is to have high availability
and the mechanism whereby the lost of a drive or multiple drives in a
single pod will not jeopardize data.
>>>>>Question<<<<<
Does partitioning the physical drives and creating btrfs filesystem on
each partition, then configuring each partition as individual
bricks/blocks offer ANY added benefits over grouping the entire pod
into a drive pool and using that pool as a single block/brick to
expose to the distributed filesystem?
