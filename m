Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58425 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab3BRKgA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 05:36:00 -0500
Message-ID: <51220437.8000209@cn.fujitsu.com>
Date: Mon, 18 Feb 2013 18:36:39 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Josef Bacik <jbacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix the deadlock between the transaction attach
 and commit
References: <5114A177.5020604@cn.fujitsu.com> <20130211203537.GB2611@localhost.localdomain> <20130212125632.GV12339@twin.jikos.cz>
In-Reply-To: <20130212125632.GV12339@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Sorry for the late reply, I was on my vacation of the Spring Festival last week.)

On Tue, 12 Feb 2013 13:56:32 +0100, David Sterba wrote:
> On Mon, Feb 11, 2013 at 03:35:37PM -0500, Josef Bacik wrote:
>> or something like that.  Me and kdave reproduced by running 274 in a loop, it
>> happpened pretty quick.  I'd fix it myself but I have to leave my house for
>> people to come look at it.  If you haven't fixed this by tomorrow I'll fix it
>> up.  Thanks,
> 
> I found 224 stuck with this
> 
[SNIP]
> 
> mounted with noatime,space_cache

Thanks for your test. My test skipped the 274th case because it always fails,
and all the other cases passed, so I didn't hit this problem.

Anyways, very sorry for my stupid patch.
(I have reviewed Josef's fix patch, and commented on it, please see the reply
of that patch)

Thanks
Miao
