Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.29.23]:57728 "EHLO
        smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754915AbcLBK1a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Dec 2016 05:27:30 -0500
Received: from [77.13.65.66] (helo=hermione.invalid)
        by smtprelay01.ispgateway.de with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.84)
        (envelope-from <envelope@m-berberich.de>)
        id 1cCkm4-0008KD-82
        for linux-btrfs@vger.kernel.org; Fri, 02 Dec 2016 11:09:00 +0100
Received: from berberic by hermione.invalid with local (Exim 4.88)
        (envelope-from <envelope@m-berberich.de>)
        id 1cCkm3-0004Kd-MW
        for linux-btrfs@vger.kernel.org; Fri, 02 Dec 2016 11:08:59 +0100
Date: Fri, 2 Dec 2016 11:08:59 +0100
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: 4.9-rc7 regression: scrub status blocks
Message-ID: <20161202100859.nywt3p3ne5i7kjbs@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

on a system with 4.9.0-rc7 I have the problem, that ‘scrub status’
blocks when a scru is running.

Example. I startet a scrub and then (in another shell) ‘scrub status’
was startet while. It blocked and returned only after the scrub
finished (hours later) with:

    WARNING: failed to read status: Connection reset by peer
    scrub status for 24717d37-4fa5-4a66-ac3c-e8f3558b3fce
	    no stats available
	    total bytes scrubbed: 0.00B with 0 errors

After the scrub ended, ‘scrub status’ returns:

    scrub status for 24717d37-4fa5-4a66-ac3c-e8f3558b3fce
	    scrub started at Thu Dec  1 20:35:15 2016 and finished after 03:48:39
	    total bytes scrubbed: 909.96GiB with 0 errors

There are no errors in dmesg.

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
