Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:35626 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751276AbdKWFsb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 00:48:31 -0500
Date: Thu, 23 Nov 2017 00:49:41 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: WARNING: CPU: 3 PID: 20953 at
 /usr/src/linux/fs/btrfs/raid56.c:848 __free_raid_bio+0x8e/0xa0
Message-ID: <20171123004941.3f50b418@Vantage.cJ>
In-Reply-To: <20171122233534.GA8475@lim.localdomain>
References: <20171120020007.01897b13@Vantage.cJ>
        <20171122233534.GA8475@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, 22 Nov 2017 15:35:35 -0800
Liu Bo <bo.li.liu@oracle.com> wrote:

> On Mon, Nov 20, 2017 at 02:00:07AM -0500, Jérôme Carretero wrote:
> > ------------[ cut here ]------------ [633254.461294] WARNING: CPU:
> > 3 PID: 20953 at /usr/src/linux/fs/btrfs/raid56.c:848
> > __free_raid_bio+0x8e/0xa0  
> 
> 
> The vanilla 4.14.0 shows it is
> WARN_ON(!bio_list_empty(&rbio->bio_list)); but we just emptied
> rbio->bio_list two lines above, i.e. struct bio *cur =
> bio_list_get(&rbio->bio_list);
> 
> Either we have some weird race, or the line number is misleading me.
> 
> Can you please check the code which warning fs/btrfs/raid56.c:848
> points to?

Same code as yours:
        WARN_ON(!bio_list_empty(&rbio->bio_list));

So yeah, at least git is not broken, now it could be a very weird
compiler bug or a less-weird race indeed...


Regards,

-- 
Jérôme
