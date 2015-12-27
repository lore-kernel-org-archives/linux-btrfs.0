Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 60-241-247-214.static.tpgi.com.au ([60.241.247.214]:40495 "EHLO
	ns1.allsupp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbbL0Olj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 09:41:39 -0500
Received: from localhost (localhost [127.0.0.1])
	by ns1.allsupp.com (Postfix) with ESMTP id E7C173FE6F
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 01:31:52 +1100 (AEDT)
Received: from ns1.allsupp.com ([127.0.0.1])
	by localhost (ns1.allsupp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id llr_FpIMwZvT for <linux-btrfs@vger.kernel.org>;
	Mon, 28 Dec 2015 01:31:32 +1100 (AEDT)
Received: from [192.168.30.72] (unknown [192.168.30.72])
	(Authenticated sender: j@ganomi.com)
	by ns1.allsupp.com (Postfix) with ESMTPSA id AF6B93FE6C
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 01:31:32 +1100 (AEDT)
To: linux-btrfs@vger.kernel.org
From: Jiri Kanicky <j@ganomi.com>
Subject: How to change BTRFS filesystem UUID
Message-ID: <567FF63E.3010106@ganomi.com>
Date: Mon, 28 Dec 2015 01:31:26 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I cloned several machines from the same disk and they all have same 
BTRFS filesystem UUID. I need to recovery one disk from failure, but if 
I attach two disks to the same machine, both disks have the same ID.

This seem to confuse UDEV, because /dev/disk/by-uuid seem to show just 
one link, not two links to two disks.

Is there a way to change the BTRFS ID (generate new one) that I can 
differentiate between the two disks on one host?

Thank you
Jiri

