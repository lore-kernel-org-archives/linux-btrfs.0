Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:54883 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbbEYCmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 May 2015 22:42:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id 2CBD81609BB
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2015 21:42:22 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 2MvqJYhTw4O2 for <linux-btrfs@vger.kernel.org>;
	Sun, 24 May 2015 21:42:21 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id D30D1160B5A
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2015 21:42:21 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tXw6GOuy7340 for <linux-btrfs@vger.kernel.org>;
	Sun, 24 May 2015 21:42:21 -0500 (CDT)
Received: from [192.168.168.20] (unknown [206.126.223.13])
	by mail.lqfe.com (Postfix) with ESMTPSA id 981991609BB
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2015 21:42:21 -0500 (CDT)
From: Anthony Plack <anthony@plack.net>
Content-Type: text/plain; charset=utf-8
Subject: Additional Debug and other various pr_ additions
Message-Id: <B6FEFB35-F6C4-41B7-9750-EC400392C0B8@plack.net>
Date: Sun, 24 May 2015 21:42:19 -0500
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Would I step on anyone’s toes if I started submitting some extra patches to increase the verbosity of the BTRFS code in the kernel log?

I would probably start with most things as pr_debug just to keep it quiet on non-debug kernels, but I just thought that it might add a great deal of clarity to the code base and maybe help sysadmins figure out what is a BTRFS issue and what is some other issue.

I have read through the Developer, SubmittingPatches, and Coding Style.  I am at peace with git.

I am not promising everything done, but what I can help with doing, I will do.

As of right now there are:

36 	pr_ 
323 	WARN_ON
506 	BUG_ON

107,197 lines of code


