Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:43614 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbcA0QYv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 11:24:51 -0500
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
	by cc-smtpout3.netcologne.de (Postfix) with ESMTP id DE62112662
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 17:24:47 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin3.netcologne.de (Postfix) with ESMTP id DA26211DBA
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 17:24:47 +0100 (CET)
Received: from [194.8.193.239] (helo=cc-smtpin3.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.9)
	(envelope-from <crohmann@netcologne.de>)
	id 56a8ef4f-0bc5-7f0000012729-7f000001d4d2-1
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 17:24:47 +0100
Received: from [194.8.193.239] (sys-239.netcologne.de [194.8.193.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 17:24:47 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Christian Rohmann <crohmann@netcologne.de>
Subject: Progress indicator when (slowly) mounting a btrfs filesystem?
Message-ID: <56A8EF4F.7060900@netcologne.de>
Date: Wed, 27 Jan 2016 17:24:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey btrfs-folks,

when one cuts the power to a machine with an 8 device RAID6 btrfs
mounted, it takes about 15 - 20 minutes to mount the btrfs again
afterwards. This is with kernel 4.4 and btrfs-progs 4.4 mind you. I
looked at iotop and it was reading from all disks heavily, so it was
doing something. The long mount time for such a rather expected case
might be a problem in itself, but either way, a mount action that takes
a while needs to present some sort of progress indication, so the user
knows what btrfs is at work getting things mounted.



Regards

Christian
