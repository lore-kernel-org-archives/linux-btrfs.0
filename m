Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:44804 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbcEDXZK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 19:25:10 -0400
Received: from smtp48.i.mail.ru (smtp48.i.mail.ru [94.100.177.108])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 195CA70B44B6
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 02:18:15 +0300 (MSK)
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:43972 helo=centurion)
	by smtp48.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1ay63Y-0000K1-Da
	for linux-btrfs@vger.kernel.org; Thu, 05 May 2016 02:18:13 +0300
Received: from [192.168.1.85] (Furia.home [192.168.1.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id 99D4CA6350
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 01:18:09 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Dmitry Katsubo <dma_k@mail.ru>
Subject: Spare volumes and hot auto-replacement feature
Message-ID: <572A8337.1030505@mail.ru>
Date: Thu, 5 May 2016 01:18:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btrfs community,

I am interested in spare volumes and hot auto-replacement feature [1]. I have a couple of questions:

* Which kernel version this feature will be included?
* The description says that replacement happens automatically when there is any write failed or flush failed. Is it possible to control the ratio / number of such failures? (e.g. in case it was one-time accidental failure)
* What happens if spare device is smaller then the (failing) device to be replaced?
* What happens if during the replacement the spare device fails (write error)?
* Is it possible for root to be notified in case if drive replacement (successful or unsuccessful) took place? Actually this question is actual for me for overall write/flush failures on btrfs volume (btrfs monitor).

Many thanks!

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg48209.html

-- 
With best regards,
Dmitry
