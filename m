Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.forwiss.uni-passau.de ([132.231.20.39]:42252 "EHLO
	mail.forwiss.uni-passau.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbbDMMt0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 08:49:26 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.forwiss.uni-passau.de (Postfix) with ESMTP id A541181DE
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:43:39 +0200 (CEST)
Received: from [2001:4ca0:107:20::15] (helo=luthien.forwiss.uni-passau.de)
	by forwiss.uni-passau.de with ESMTP (eXpurgate 4.0.6)
	(envelope-from <berberic@forwiss.uni-passau.de>)
	id 552bb9fb-0c05-20014ca00107002000000000000000390019-20014ca0010700200000000000000015b78c-1
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:43:39 +0200
Date: Mon, 13 Apr 2015 14:43:39 +0200
From: M G Berberich <berberic@fmi.uni-passau.de>
To: linux-btrfs@vger.kernel.org
Subject: BtrFS and encryption
Message-ID: <20150413124339.GA13828@forwiss.uni-passau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

it seems that ext4 is getting encryption-support

  http://thread.gmane.org/gmane.comp.file-systems.ext4/48206

rumors say because of performance-problems with eCryptFS in Android.
f2fs should get a compatible interface too.

I would like to see this in BtrFS as well…

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic
