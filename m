Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailer.hiddenmail.net ([199.195.249.9]:46449 "EHLO
	mailer.hiddenmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbcBPWVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 17:21:34 -0500
Received: from mailer by mailer.hiddenmail.net with local (Exim 4.80)
	(envelope-from <angel@fs.16bits.net>)
	id 1aVnzw-0001PR-K1
	for linux-btrfs@vger.kernel.org; Tue, 16 Feb 2016 23:21:32 +0100
Message-ID: <1455661288.1700.8.camel@fs.16bits.net>
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
From: =?ISO-8859-1?Q?=C1ngel_Gonz=E1lez?= <angel@fs.16bits.net>
To: "inux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 16 Feb 2016 23:21:28 +0100
In-Reply-To: <56C27D8F.2000006@cn.fujitsu.com>
References: <1447365063.7045.7.camel@scientia.net>
	 <1455581697.6951.9.camel@fs.16bits.net> <56C27D8F.2000006@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> > Which should be my next steps?
> > 
> 
> Try btrfs-progs 4.4 to see if all these false alert goes a way.
> 
> Thanks,
> Qu

Thanks!
Those "errors" are indeed gone after updating btrfs-progs from 4.3.1 to
4.4. Sorry for the fuss.


It's strange though if it was supposed to only happen with non-skinny
metadata, since I didn't manually specify any flags, and supposedly
skinny is the default since 3.18 (the btrfs partition was created with
a newer version).


Thanks for your support
