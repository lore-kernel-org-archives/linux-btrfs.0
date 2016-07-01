Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp45.i.mail.ru ([94.100.177.105]:58839 "EHLO smtp45.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbcGAUOG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jul 2016 16:14:06 -0400
Received: from 82-169-65-155.ip.telfort.nl ([82.169.65.155]:32994 helo=centurion.home)
	by smtp45.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1bJ4p8-0000hh-4o
	for linux-btrfs@vger.kernel.org; Fri, 01 Jul 2016 23:14:02 +0300
Received: from [192.168.1.85] (Furia.home [192.168.1.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion.home (Postfix) with ESMTPSA id C421F23EB01
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Jul 2016 22:13:59 +0200 (CEST)
From: Dmitry Katsubo <dma_k@mail.ru>
Subject: btrfs defrag questions
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <5776CF08.5040601@mail.ru>
Date: Fri, 1 Jul 2016 22:14:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Question #1:

While doing defrag I got the following message:

# btrfs fi defrag -r /home
ERROR: defrag failed on /home/user/.dropbox-dist/dropbox: Success
total 1 failures

I feel that something went wrong, but the message is a bit misleading.

Provided that Dropbox is running in the system, does it mean that it
cannot be defagmented?

Question #2:

Suppose that in above example /home/ftp is mounted as another btrfs
array (not subvolume). Will 'btrfs fi defrag -r /home' defragment it
(recursively) as well?

-- 
With best regards,
Dmitry
