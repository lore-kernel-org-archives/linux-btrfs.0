Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:50363 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3BDM6S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 07:58:18 -0500
Received: from webmail.tu-dortmund.de (vmx028.itmc.tu-dortmund.de [129.217.131.82])
	by unimail.uni-dortmund.de (8.14.6/8.14.5) with ESMTP id r14CbLR8017966
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Feb 2013 13:37:21 +0100 (CET)
Message-ID: <687dbd42013568bf82390c86d4661ce4.squirrel@webmail.tu-dortmund.de>
Date: Mon, 4 Feb 2013 13:37:21 +0100
Subject: Does btrfs adapt to size changes of underlying block device(s)?
From: "Simon Campese" <simon.campese@tu-dortmund.de>
To: linux-btrfs@vger.kernel.org
Reply-To: simon.campese@tu-dortmund.de
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've got a quick question: Does btrfs adapt to size changes of the
underlying block device(s)?

My specific situation is as follows: I've got a luks-volume on which I
want to put btrfs. If this luks-volume grows in the future (i.e. by
'cryptsetup resize'), will btrfs automatically (and reliably) "see" this
and be able to use the additional space?

Of course, one can always put an lvm-layer in between, but I would really
like to avoid this.

And as we're at it: What about shrinking of the underlying block-device?


Thanks for your help,

Simon

