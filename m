Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:45001 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772AbbD0MxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 08:53:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id 36CC916380A
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 07:48:02 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id jajOIFN8NYBr for <linux-btrfs@vger.kernel.org>;
	Mon, 27 Apr 2015 07:48:01 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id B5EFE1637A8
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 07:48:01 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vfoW6kTeWOVn for <linux-btrfs@vger.kernel.org>;
	Mon, 27 Apr 2015 07:48:01 -0500 (CDT)
Received: from [192.168.168.20] (unknown [206.126.223.13])
	by mail.lqfe.com (Postfix) with ESMTPSA id 743BD1608C9
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 07:48:01 -0500 (CDT)
From: Anthony Plack <anthony@plack.net>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs-progs SCRUB reporting aborted but still running - minor
Message-Id: <A08BD340-C5DA-4852-B38B-7314CCAD3E3F@plack.net>
Date: Mon, 27 Apr 2015 07:48:00 -0500
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a BTRFS which has errors. After starting a scrub, and checking status once, scrub will report it was aborted but still runs to completion.

fatdrive ~ # btrfs scrub status /mnt/data
scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon Apr 27 06:48:44 2015, running for 224 seconds
	total bytes scrubbed: 223.10GiB with 0 errors
fatdrive ~ # btrfs scrub status /mnt/data
scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 1089 seconds
	total bytes scrubbed: 1.02TiB with 0 errors
fatdrive ~ # btrfs scrub status /mnt/data
scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 1664 seconds
	total bytes scrubbed: 1.53TiB with 0 errors
fatdrive ~ # btrfs scrub status /mnt/data
scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 1669 seconds
	total bytes scrubbed: 1.54TiB with 0 errors
fatdrive ~ # btrfs scrub status /mnt/data
scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 1705 seconds
	total bytes scrubbed: 1.56TiB with 0 errors

Scrub does seem to be processing, so this is just a text/status issue.

I have opened issue 97341 for this.   https://bugzilla.kernel.org/show_bug.cgi?id=97341