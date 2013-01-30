Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:60899 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3A3Sau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 13:30:50 -0500
Received: by mail-ie0-f181.google.com with SMTP id 17so1553228iea.40
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 10:30:50 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: corrupted file size on inline extent conversion?
From: Mike Lowe <j.michael.lowe@gmail.com>
In-Reply-To: <20130130182213.GI3660@localhost.localdomain>
Date: Wed, 30 Jan 2013 13:30:49 -0500
Cc: Sage Weil <sage@inktank.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "billk@iinet.net.au" <billk@iinet.net.au>
Message-Id: <949A937F-7E0F-47E9-B63F-EC58E3B6370C@gmail.com>
References: <alpine.DEB.2.00.1301281602060.8729@cobra.newdream.net> <20130129145429.GD3660@localhost.localdomain> <08479684-218C-4B6E-8D76-DE39B36EE12E@gmail.com> <20130130182213.GI3660@localhost.localdomain>
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been running rsync against a rbd device backed by btrfs filesystems that are about 11% full for about 45 minutes before I checked and noticed the printk message.  That was the first go with the patch.  Seems like I was able to get by without any problems until the btrfs filesystems got some use and filled up a little bit.

On Jan 30, 2013, at 1:22 PM, Josef Bacik <jbacik@fusionio.com> wrote:

> On Wed, Jan 30, 2013 at 11:17:25AM -0700, Mike Lowe wrote:
>> Well I found this, so I think it's likely:
>> 
>> root@gwboss2:~# dmesg |grep bitten
>> [ 3196.193238] this would have bitten us in the ass
>> [ 3196.193784] this would have bitten us in the ass
>> 
> 
> Well that makes me happy since I had almost talked myself out of this being a
> possiblity.  How long did it take you to hit this problem before and how long
> have you been running with this patch?  Thanks,
> 
> Josef

