Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:43677 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaFDL1D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 07:27:03 -0400
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
	by cc-smtpout2.netcologne.de (Postfix) with ESMTP id 57208126CF
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Jun 2014 13:19:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin3.netcologne.de (Postfix) with ESMTP id 271FF11DC3
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Jun 2014 13:19:17 +0200 (CEST)
Received: from [84.44.239.144] (helo=cc-smtpin3.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.2)
	(envelope-from <s.schumacher@netcologne.de>)
	id 538f00b5-0b5e-7f0000012729-7f000001c309-1
	for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 13:19:17 +0200
Received: from mars.solar.net (xdsl-84-44-239-144.netcologne.de [84.44.239.144])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Jun 2014 13:19:16 +0200 (CEST)
Date: Wed, 4 Jun 2014 13:19:16 +0200
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
To: linux-btrfs@vger.kernel.org
Subject: Partition tables / Output of parted
Message-ID: <20140604111916.GB1657@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I have created multiple filesystems with btrfs, in all cases directly
on the devices themself without creating partitions beforehand.  Now,
if I open the disks containing the multi-device filesystem in parted
it outputs the partion table as loop and shows one partition with
btrfs which covers the whole disk. Opening the disk with the
single-device fileystem in parted shows a partion table, type unknown
and no partition on the disk itself. 

I am unsure how to interpret this output. Two possible explanations
come to mind: a) Btrfs does create partitions, but only if a filesystem spans
multiple devices or b) the output of parted is faulty and no actual
partition is created in both cases. 

Could someone elaborate on this question or just point out where I can
find documentation on this issue?

Yours sincerely
Stefan 
