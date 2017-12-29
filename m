Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46105 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdL2RXD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 12:23:03 -0500
Subject: Re: WARNING: CPU: 1 PID: 3016 at fs/btrfs/ctree.h:1564
 btrfs_update_device+0x189/0x190 [btrfs]
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
References: <20171229163312.b3k7rfagcycz5mvf@galadriel.home.lxtec.de>
 <0a34347a-ae74-dbab-98bd-08d822347c9b@applied-asynchrony.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0b81a3bf-958a-7c82-eea0-a04c916703b1@suse.com>
Date: Fri, 29 Dec 2017 19:23:00 +0200
MIME-Version: 1.0
In-Reply-To: <0a34347a-ae74-dbab-98bd-08d822347c9b@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.12.2017 19:07, Holger Hoffstätte wrote:
> 
> Apply the patch from https://patchwork.kernel.org/patch/9960893/
> and follow the logged instructions re. device resizing (or see
> https://bugzilla.kernel.org/show_bug.cgi?id=196949 for examples).
> 
> The patch is unfortunately not yet merged into 4.15rc, otherwise it
> could be sent to 4.14-stable.
> 

This is not the correct way to resolve the issue. Rather, Qu has sent a
patch for btrfs-progs which does the correct repair. The code in
question is in btrfs progs 4.14.


So OP:

Update your btrfs-progs package to latest 4.14 and run btrfs rescue :

btrfs rescue fix-device-size <device>
> -h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
