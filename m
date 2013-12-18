Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from c62.cesmail.net ([216.154.195.54]:8932 "EHLO c62.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab3LRTP4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 14:15:56 -0500
Message-ID: <20131218140615.dbjsgs7zkssgckos-cebfxv@webmail.spamcop.net>
Date: Wed, 18 Dec 2013 14:06:15 -0500
From: Pavel Roskin <proski@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: Backporting bugfixes
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I have noticed that there have been important fixes for btrfs in the  
mainline Linux git repository.  However, there is just one btrfs fix  
in Linux 3.12.5 after 3.12.

I think it's important to submit all serious bugfixes to the stable  
kernels.  It would protect users against data corruption and improve  
the image of btrfs as a serious filesystem that can be trusted at  
least with semi-important data.

This post was inspired by http://lwn.net/Articles/577218/ and
https://bugzilla.redhat.com/show_bug.cgi?id=1028750

-- 
Regards,
Pavel Roskin
