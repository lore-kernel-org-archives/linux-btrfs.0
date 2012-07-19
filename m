Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v1238.ncsrv.de ([89.110.148.232]:43677 "EHLO
	stinkt.kicks-ass.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2GSCJr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 22:09:47 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by stinkt.kicks-ass.org (iRedMail) with ESMTP id C18C91854800D
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2012 04:00:43 +0200 (CEST)
Received: from stinkt.kicks-ass.org ([127.0.0.1])
	by localhost (v1238.ncsrv.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lEEsCfOKSCAW for <linux-btrfs@vger.kernel.org>;
	Thu, 19 Jul 2012 04:00:43 +0200 (CEST)
Received: from [192.168.178.59] (91-119-132-149.dynamic.xdsl-line.inode.at [91.119.132.149])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinkt.kicks-ass.org (iRedMail) with ESMTPSA id 5AF041854800C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2012 04:00:43 +0200 (CEST)
Message-ID: <50076A4C.8080400@stinkt.kicks-ass.org>
Date: Thu, 19 Jul 2012 04:00:44 +0200
From: Bernhard Redl <bernhard@stinkt.kicks-ass.org>
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: Very slow samba file transfer speed... any ideas ?
References: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com>
In-Reply-To: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Did you try creating an huge file directly on your linux host
with

dd if=/dev/zero of=/mnt/<YOURPATH>/file bs=1M count=1400

dd will report the speed afterwards.
You can also try copying the documents from ext4 to a ramfs and then
copy them from the ramfs to btrfs.


On 07/19/2012 03:42 AM, Shavi N wrote:
> Hi,
> 
> I have btrfs volume, shared via samba. I have a directory of
> documents that I want to backup on my server. win7 reports a
> maximum of ~3.10MB/s transfer transferring the same directory on a
> ext4 samba share I get 25MB/s +
> 
> Any ideas? Is it like that because of how btrfs works and is
> setup?
> 
> Thanks, -- To unsubscribe from this list: send the line
> "unsubscribe linux-btrfs" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 


