Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.smcindiaonline.com ([59.144.72.228]:56180 "EHLO
	mail2.smcindiaonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932532Ab3LIMTD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 07:19:03 -0500
Received: from mail2.smcindiaonline.com (localhost [127.0.0.1])
	by mail2.smcindiaonline.com (8.14.7/8.14.7) with ESMTP id rB9CIx9t020234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Dec 2013 17:48:59 +0530
Received: (from vikram@localhost)
	by mail2.smcindiaonline.com (8.14.7/8.14.7/Submit) id rB9CIwAA020233
	for linux-btrfs@vger.kernel.org; Mon, 9 Dec 2013 17:48:58 +0530
Date: Mon, 9 Dec 2013 17:48:56 +0530
From: Vikram Goyal <vikigoyal@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: scub neither running nor canceling nor can be restarted.
Message-ID: <20131209121856.GA18083@mail2.smcindiaonline.com>
Reply-To: Vikram Goyal <vikigoyal@gmail.com>
References: <20131209095133.GA6579@mail2.smcindiaonline.com>
 <52A59EF7.8050007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52A59EF7.8050007@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 09, 2013 at 06:44:07PM +0800, Wang Shilong wrote:
> Hello Vikram,
> 
> On 12/09/2013 05:51 PM, Vikram Goyal wrote:
> >Hello,
> >
> >I am having a problem where a stuck scrub on root FS cannot be
> >cancelled or restsrted.
> >
<snip>
> >To cancel use 'btrfs scrub cancel /'.
> >To see the status use 'btrfs scrub status [-d] /'.
> I came the same issue before and i sent a patch for this:
> https://patchwork.kernel.org/patch/3264051/
> 
> This patch has been merged into David's integration branch.
> You can pull from:
> 
> https://github.com/kdave/btrfs-progs.git integration-20131206
> 
> you can use:
> # btrfs scrub start -f /
> 
> This should help, -f will force us to skip check in userspace.
> 
> Thanks,
> Wang

Hello Wang,

I am on Fedora 19. I just checked, I don't have -f as option in
btrfs-progs. The installed version is:

btrfs-progs.x86_64                  3.12-1.fc18         @updates

current kernel is 3.11.9-100.fc18.x86_64

I just wanted to know if its not dangerous to have this state of FS
since I will wait for the update to come from the repo rather than build
package myself

Thanks!
-- 
