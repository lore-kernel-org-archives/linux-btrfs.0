Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:34636 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab2KNVN4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 16:13:56 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID lutz.euler@freenet.de) (port 25) (Exim 4.76 #1)
	id 1TYkHS-0006fk-Sz
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:13:54 +0100
Received: from localhost ([::1]:56049 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.76 #1)
	id 1TYkHS-0005aM-Ox
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:13:54 +0100
Received: from [195.4.92.11] (port=38104 helo=1.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.76 #1)
	id 1TYkEb-0004lI-Gr
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:10:57 +0100
Received: from p548fd96b.dip.t-dialin.net ([84.143.217.107]:57100 helo=lutz)
	by 1.mx.freenet.de with esmtpsa (ID lutz.euler@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1TYkEb-0001Id-9r
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:10:57 +0100
Received: from lutz by lutz with local (Exim 4.74)
	(envelope-from <lutz.euler@freenet.de>)
	id 1TYkEa-0001x5-4D
	for linux-btrfs@vger.kernel.org; Wed, 14 Nov 2012 22:10:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20644.2272.57892.435731@localhost.localdomain>
Date: Wed, 14 Nov 2012 22:10:56 +0100
From: lutz.euler@freenet.de (Lutz Euler)
To: linux-btrfs@vger.kernel.org
Subject: Re: Bulk discard doesn't work after add/delete of devices
References: <20270.59513.240729.662692@localhost.localdomain>
	<4F3386D8.6010108@cn.fujitsu.com>
	<20275.60248.386622.516828@localhost.localdomain>
	<4F34795B.2020004@cn.fujitsu.com>
	<20279.61547.888033.662423@localhost.localdomain>
	<20301.28303.484287.126799@localhost.localdomain>
	<20356.28427.586846.710401@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the issue I raised in this thread is still not fixed. So, to get things
going, I prepared a patch myself which I will send in a separate email.
The subject will be "really fix trim 0 bytes after a device delete".
I would be grateful if you could consider the patch -- with it applied
I finally could trim my disks successfully.

Greetings,

Lutz
