Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp48.i.mail.ru ([94.100.177.108]:50617 "EHLO smtp48.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbcEYOpv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 10:45:51 -0400
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:33904 helo=centurion)
	by smtp48.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1b5a4C-0001yq-4S
	for linux-btrfs@vger.kernel.org; Wed, 25 May 2016 17:45:48 +0300
Received: from www.centurion.link (localhost [IPv6:::1])
	by centurion (Postfix) with ESMTP id 2669B115A95
	for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 16:45:41 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 25 May 2016 16:45:41 +0200
From: Dmitry Katsubo <dma_k@mail.ru>
To: linux-btrfs@vger.kernel.org
Subject: Some ideas for improvements
Message-ID: <45a47ee4db4cc92248f91f1d00e8ed03@www.centurion.link>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btrfs community,

I hope btrfs developers are open for suggestions.

btrfs-scrub:

* Would be nice if 'btrfs scrub status' shows estimated finishing time 
(ETA) and throughput (in Mb/s).
* Not possible to start scrub for all devices in the volume without 
mounting it.

btrfs-restore:

* It does not restore special files like named pipes and devices.
* Hard-linked files are not correctly restored (they all turn into 
independent replicas).
* If the file cannot be read / recovered, it is still created with zero 
size (I would expect that the file is not created).
* I think that the options '-xmS' should be enabled by default 
(shouldn't it be a goal to restore as much as possible?).
* Option that applies (y) to all questions (completely unattended 
recovery) is missing.

-- 
With best regards,
Dmitry
