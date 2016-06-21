Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.181.169]:52330 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcFUXjz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 19:39:55 -0400
Received: from smtp29.i.mail.ru (smtp29.i.mail.ru [94.100.177.89])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id 3DA4C1E43E36
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 02:39:25 +0300 (MSK)
Received: from 82-169-65-155.ip.telfort.nl ([82.169.65.155]:44154 helo=centurion.home)
	by smtp29.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1bFVEg-0007dC-4I
	for linux-btrfs@vger.kernel.org; Wed, 22 Jun 2016 02:37:38 +0300
Received: from [192.168.1.85] (Furia.home [192.168.1.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion.home (Postfix) with ESMTPSA id 83E161DCFD6
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 01:37:35 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Dmitry Katsubo <dma_k@mail.ru>
Subject: btrfs defrag: success or failure?
Message-ID: <5769CFC2.2050005@mail.ru>
Date: Wed, 22 Jun 2016 01:37:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I got the following message:

# btrfs fi defrag -r /home
ERROR: defrag failed on /home/user/.dropbox-dist/dropbox: Success
total 1 failures

I feel that something went wrong, but the message is a bit misleading.

Anyway: Provided that Dropbox is running in the system, does it mean
that it cannot be defagmented?

-- 
With best regards,
Dmitry
