Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:45033 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbbD0M6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 08:58:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id 314A11608C9
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 07:51:16 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id WcaDMAYI0UQq for <linux-btrfs@vger.kernel.org>;
	Mon, 27 Apr 2015 07:51:15 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id D47561637A8
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 07:51:15 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bC6ul0EjlkfE for <linux-btrfs@vger.kernel.org>;
	Mon, 27 Apr 2015 07:51:15 -0500 (CDT)
Received: from [192.168.168.20] (unknown [206.126.223.13])
	by mail.lqfe.com (Postfix) with ESMTPSA id 95E3C1608C9
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 07:51:15 -0500 (CDT)
From: Anthony Plack <anthony@plack.net>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs-progs BTRFS mounted with -o recovery showing no errors on scrub - minor
Message-Id: <D06066B0-F26E-4F1D-BFF5-E6BC8CDB68B1@plack.net>
Date: Mon, 27 Apr 2015 07:51:14 -0500
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This may be by design since the driver is handling the errors. When the drive is mounted with -o recovery, and then a scrub is performed, scrub will show no errors. 

fatdrive ~ # dmesg | tail
[35348.694291] repair_io_failure: 4 callbacks suppressed
[35348.694297] BTRFS: read error corrected: ino 1 off 93863407616 (dev /dev/sds sector 183326968)
[35351.029568] BTRFS (device sdt): parent transid verify failed on 8392192475136 wanted 148989 found 147789
[35351.048101] BTRFS: read error corrected: ino 1 off 8392192475136 (dev /dev/sds sector 2314785632)
[35470.018881] BTRFS (device sdt): parent transid verify failed on 94051291136 wanted 150686 found 150687
[35470.150372] BTRFS (device sdt): parent transid verify failed on 94051291136 wanted 150686 found 150687
[35948.602971] BTRFS (device sdt): parent transid verify failed on 94238015488 wanted 150690 found 150691
[35948.608723] BTRFS (device sdt): parent transid verify failed on 94238015488 wanted 150690 found 150691
[36114.453009] BTRFS (device sdt): parent transid verify failed on 94238015488 wanted 150690 found 150691
[36114.472586] BTRFS (device sdt): parent transid verify failed on 94238015488 wanted 150690 found 150691
fatdrive ~ # btrfs scrub status /mnt/data
scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 2651 seconds
	total bytes scrubbed: 2.39TiB with 0 errors

I have reported this as issue 97351. https://bugzilla.kernel.org/show_bug.cgi?id=97351