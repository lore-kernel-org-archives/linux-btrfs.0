Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33434 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952AbbLBJzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 04:55:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 6EE7B34C510
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Dec 2015 10:46:31 +0100 (CET)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j-_xaLC155Xz for <linux-btrfs@vger.kernel.org>;
	Wed,  2 Dec 2015 10:46:30 +0100 (CET)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Dec 2015 10:46:30 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 02 Dec 2015 18:46:30 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: compression disk space saving - what are your results?
Message-ID: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What are your disk space savings when using btrfs with compression?

I have a 200 GB btrfs filesystem which uses compress=zlib, only stores 
text files (logs), mostly multi-gigabyte files.


It's a "single" filesystem, so "df" output matches "btrfs fi df":

# df -h
Filesystem      Size  Used Avail Use% Mounted on
(...)
/dev/xvdb       200G  124G   76G  62% /var/log/remote


# du -sh /var/log/remote/
153G    /var/log/remote/


 From these numbers (124 GB used where data size is 153 GB), it appears 
that we save around 20% with zlib compression enabled.
Is 20% reasonable saving for zlib? Typically text compresses much better 
with that algorithm, although I understand that we have several 
limitations when applying that on a filesystem level.


Tomasz Chmielewski
http://wpkg.org

