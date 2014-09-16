Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45786 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753965AbaIPA4p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 20:56:45 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49307 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XTh4W-000c4s-9i
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 18:56:44 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: unable to mount, tools segfault
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPDSe6sip7UR3kge=aNedn6T1xhQmcEQHFCSm=JGDEibtRkOLw@mail.gmail.com>
Date: Mon, 15 Sep 2014 18:56:42 -0600
Message-Id: <5F01E283-D95E-4F81-B358-6470ABD58C0D@colorremedies.com>
References: <CAPDSe6sip7UR3kge=aNedn6T1xhQmcEQHFCSm=JGDEibtRkOLw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 15, 2014, at 3:41 PM, Tony Murray <murraytony@gmail.com> wrote:
> 
> # btrfs restore -v -i /dev/sda7 /mnt/sdb1/

Starting with umounted volume:

btrfs check <dev>
btrfs-debug-tree -R <dev>


Chris Murphy
