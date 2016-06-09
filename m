Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:59056 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbcFIPt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 11:49:56 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.85 #1)
	id 1bB2DS-000060-Ci
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 17:49:54 +0200
Received: from localhost ([::1]:48843 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1bB2DS-0004PJ-86
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 17:49:54 +0200
Received: from mx8.freenet.de ([195.4.92.18]:57495)
	by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1bB2B3-0003Oa-6T
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 17:47:25 +0200
Received: from ppp-88-217-1-15.dynamic.mnet-online.de ([88.217.1.15]:33736 helo=[192.168.1.204])
	by mx8.freenet.de with esmtpsa (ID master.b.at.raven@chefmail.de) (TLSv1.2:DHE-RSA-AES128-SHA:128) (port 465) (Exim 4.85 #1)
	id 1bB2B3-0004W9-2o
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 17:47:25 +0200
Subject: Re: WARNING: at /home/kernel/COD/linux/fs/btrfs/inode.c:9261
 btrfs_destroy_inode+0x247/0x2c0 [btrfs]
References: <CAO8gOzMt2Wgb2jZ-eq-an-RqHPgssMgZ+O1jOxmZ4GPc-MdDYw@mail.gmail.com>
 <pan$282ab$fbadc095$ca288943$dfa7a0b@cox.net>
To: linux-btrfs@vger.kernel.org
From: g6094199@freenet.de
Message-ID: <17049685-7c06-6e09-2aa6-25c4bda6139b@chefmail.de>
Date: Thu, 9 Jun 2016 17:47:26 +0200
MIME-Version: 1.0
In-Reply-To: <pan$282ab$fbadc095$ca288943$dfa7a0b@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 09.06.2016 um 16:52 schrieb Duncan:
> Fugou Nashi posted on Sun, 05 Jun 2016 10:12:31 +0900 as excerpted:
>
>> Hi,
>>
>> Do I need to worry about this?
>>
>> Thanks.
>>
>> Linux nakku 4.6.0-040600-generic #201605151930 SMP Sun May 15 23:32:59
>> UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> There's a patch for it that didn't quite make 4.6.0, but is in 4.7-rc1 
> and should appear in later 4.6.x stable releases (tho I don't track 
> stable myself so couldn't tell you if it's there yet or not).
>
> In general, some people were reporting many of these warnings during the 
> 4.6 rcs with no visible damage or further problems, so it doesn't tend to 
> be anything but the irritation of the warnings in practice, tho under the 
> right conditions, in theory, it could be a bigger issue.  But I know of 
> no one who actually experienced a problem beyond the warn noise.
>
> So in practice it's a get the patch as soon as you can thing, but not 
> something to be hugely worried about in the mean time.
>
FYI

i run into the same error on debian sid with 4.6.0....and holger pointed
out:

This is 4.6.0-whatever, not 4.6.1. The problem is fixed in the real
4.6.1 (released last week), which you can find described in commit 4704fa54..
at https://cdn.kernel.org/pub/linux/kernel/v4.x/ChangeLog-4.6.1

-h


