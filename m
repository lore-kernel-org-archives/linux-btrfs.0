Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:58080 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbaGHTNh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 15:13:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id 7CCEB123E0
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Jul 2014 21:07:33 +0200 (CEST)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 23934-04 for <linux-btrfs@vger.kernel.org>;
 Tue,  8 Jul 2014 21:07:31 +0200 (CEST)
Received: from [IPv6:2001:15c0:65ff:8742:18e:166d:2c2c:c1be] (unknown [IPv6:2001:15c0:65ff:8742:18e:166d:2c2c:c1be])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id 10721123CA
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Jul 2014 21:07:30 +0200 (CEST)
Message-ID: <53BC4172.8080300@xunil.at>
Date: Tue, 08 Jul 2014 21:07:30 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs and mount in gentoo linux
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello, btrfs-mailing-list,

I already tried to contact Chris Mason via pm but so far I didn't get a
reply so I taking this approach now:

I am a happy btrfs-user with gentoo linux for some time now and noticed
that the command "mount" does not show me which subvolid is mounted where.

eg.

# mount | grep sda2

/dev/sda2 on /mnt/btrfs_pool1 type btrfs
(rw,noatime,compress=lzo,ssd,space_cache)

/dev/sda2 on /mnt/oopsfiles type btrfs
(rw,noatime,compress=lzo,ssd,space_cache)

/dev/sda2 on /home type btrfs (rw,noatime,compress=lzo,ssd,space_cache)

See?

I filed a bug against util-linux at bugs.gentoo.org:

https://bugs.gentoo.org/show_bug.cgi?id=510148

but as you see from Comment 5 it isn't resolved yet due to "don't know" ;-)


Can you tell me where the problem/solution might be located?
Is it a known behavior in a way ... ?

Thanks for looking into it, I appreciate it ... I will then see to
report things back at the gentoo bugzilla to help improving btrfs
support in gentoo!

Regards, Stefan
