Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58950 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbcBVXfH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 18:35:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aY00O-0002pY-HF
	for linux-btrfs@vger.kernel.org; Tue, 23 Feb 2016 00:35:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 00:35:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 00:35:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: restore: make btrfs restore able to read a
 file which lists files to restore
Date: Mon, 22 Feb 2016 23:32:29 +0000 (UTC)
Message-ID: <pan$66f1d$6cf7133f$d6adad01$12a46a68@cox.net>
References: <1456163603-6712-1-git-send-email-solenskiner@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henrik Asp posted on Mon, 22 Feb 2016 18:53:23 +0100 as excerpted:

> --path-regex' syntax does not map well to restoring specific files.
> this patch introduces --path-from-file which takes a file listing files
> to restore.

I can't speak to the quality of the patch, but as someone who appreciates 
the usefulness of btrfs restore, I definitely like the idea! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

