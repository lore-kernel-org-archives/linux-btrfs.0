Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:34964 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2JHQPy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 12:15:54 -0400
Message-ID: <5072FC37.8090105@petaramesh.org>
Date: Mon, 08 Oct 2012 18:15:51 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <20121008160933.GA2259@localhost.localdomain>
In-Reply-To: <20121008160933.GA2259@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 08/10/2012 18:09, Josef Bacik a écrit :
> Can you get sysrq+w when you are seeing slowness?  Usually bootup slow times
> means you don't have space_cache enabled or your cache is being evicted for some
> reason, can you check dmesg after bootup for messages related to space cache?
> Thanks,
 I have a few :

Oct  8 15:27:26 tethys kernel: [16174.736603] btrfs: free space inode
generation (0) did not match free space cache generation (106988)
Oct  8 15:27:27 tethys kernel: [16175.976784] btrfs: free space inode
generation (0) did not match free space cache generation (30727)
Oct  8 15:27:28 tethys kernel: [16176.420719] btrfs: free space inode
generation (0) did not match free space cache generation (48040)
Oct  8 15:27:28 tethys kernel: [16176.710972] btrfs: free space inode
generation (0) did not match free space cache generation (30745)

...in syslog, but that's about all... and not during boot...

I used to have much much more of these in syslog, but solved it by
booting once with the "clear_cache" option, that caused boot to be
extremely slow, but seemed to fix it...

(Remember I have such issues on several machines, it is highly
improbable that all of them would get their cache ignored...?)

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

