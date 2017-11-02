Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:42971 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbdKBWGo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 18:06:44 -0400
Reply-To: waxhead@dirtcellar.net
Subject: =?UTF-8?Q?Re:_Parity-based_redundancy_=28RAID5/6/triple_parity_and_?=
 =?UTF-8?Q?beyond=29_on_BTRFS_and_MDADM_=28Dec_2014=29_=e2=80=93_Ronny_Egner?=
 =?UTF-8?Q?s_Blog?=
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAH=dxU4vj_+_K9dE3hqMf42oC9wEJKXTPRDr6QyOjrQfEXmXXA@mail.gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <7178555e-5f84-4e8a-243e-f1108d06136e@dirtcellar.net>
Date: Thu, 2 Nov 2017 23:06:41 +0100
MIME-Version: 1.0
In-Reply-To: <CAH=dxU4vj_+_K9dE3hqMf42oC9wEJKXTPRDr6QyOjrQfEXmXXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave wrote:
> Has this been discussed here? Has anything changed since it was written?
>
I have (more or less) been following the mailing list since this feature 
was suggested. I have been drooling over it since, but not much have 
happened.

> Parity-based redundancy (RAID5/6/triple parity and beyond) on BTRFS
> and MDADM (Dec 2014) – Ronny Egners Blog
> http://blog.ronnyegner-consulting.de/2014/12/10/parity-based-redundancy-raid56triple-parity-and-beyond-on-btrfs-and-mdadm-dec-2014/comment-page-1/
>
> TL;DR: There are patches to extend the linux kernel to support up to 6
> parity disks but BTRFS does not want them because it does not fit
> their “business case” and MDADM would want them but somebody needs to
> develop patches for the MDADM component. The kernel raid
> implementation is ready and usable. If someone volunteers to do this
> kind of work I would support with equipment and myself as a test
> resource.
> --
I am just a list "stalker" and no BTRFS developer, but as others have 
indirectly said already. It is not so much that BTRFS don't want the 
patches as it is that BTRFS do not want to / can't focus on this right 
now due to other priorities.

There was some updates to raid5/6 in kernel 4.12 that should fix (or at 
least improve) scrub/auto-repair. The write hole does still exist.

That being said there might be configurations where btrfs raid5/6 might 
be of some use. I think I read somewhere that you can set data to 
raid5/6 and METADATA to raid1 or 10 and you would risk loosing some data 
(but not the filesystem) in the event of a system crash / power failure.

This sounds tempting since it in theory would not make btrfs raid 5/6 
significantly less reliable than other RAID's which will corrupt your 
data if the disk happens to spits out bad bits without complaining (one 
possible exception that might catch this is md raid6 which I use). That 
being said there is no way I would personally use btrfs raid 5/6 even 
with metadata raid1/10 yet without proper tested backups at standby at 
this point.

Anyway - I would worry more about getting raid5/6 to work properly 
before even thinking about multi-parity at all :)

> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
