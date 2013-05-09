Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51789 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3EIHLI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 03:11:08 -0400
Received: by mail-pb0-f54.google.com with SMTP id rr4so1786297pbb.41
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 00:11:07 -0700 (PDT)
Date: Thu, 9 May 2013 15:28:45 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, linux-btrfs@vger.kernel.org,
        sekharan@us.ibm.com, chris.mason@fusionio.com,
        Ilya Dryomov <idryomov@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Message-ID: <20130509072845.GA16978@gmail.com>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
 <CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com>
 <518B4274.3020000@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <518B4274.3020000@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 09, 2013 at 08:30:12AM +0200, Stefan Behrens wrote:
> On 05/09/2013 01:13, Zhi Yong Wu wrote:
> >HI, all
> >
> >    I saw that bcache will be merged into kernel upstream soon, so i
> >want to know if btrfs hot relocation support is still meanful, if no,
> >i will not continue to work on it. can anyone let me know this?
> >thanks.
> 
> Which one is better?
> 
> Please do some measurements. Select typical file system use cases,
> and publish and compare the measurement results of the two
> approaches.

Hi Stefan,

AFAIU, the key issue is that the hot relocation feature should be
implemented in file system or in block device because file system knows
which data is hot, and the application could use fadvise/ioctl/...
interfaces to give a hint to file system to keep some data in fast
device.  But IIUC dm-cache/bcache only can do is like: "hey, this data
should be hot just because it is touched twice."  In some cases, touched
twice not always means that it should be kept in fast device.

Regards,
                                                - Zheng
