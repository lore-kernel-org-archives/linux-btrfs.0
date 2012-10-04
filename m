Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:21745 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964926Ab2JDOXY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 10:23:24 -0400
Message-ID: <506D9BC2.1050508@oracle.com>
Date: Thu, 04 Oct 2012 22:22:58 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH 2/2 v3] Btrfs: snapshot-aware defrag
References: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com> <1347875936-14165-2-git-send-email-bo.li.liu@oracle.com> <CAKcLGm_4iUB1B8DPOx1D7i8eMa7po9fWFUYVOqp1N9nmZ1ExHQ@mail.gmail.com> <50625569.9040102@oracle.com> <20121003140259.GA4458@shiny>
In-Reply-To: <20121003140259.GA4458@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 10:02 PM, Chris Mason wrote:
> On Tue, Sep 25, 2012 at 07:07:53PM -0600, Liu Bo wrote:
>> On 09/26/2012 01:39 AM, Mitch Harder wrote:
>>> On Mon, Sep 17, 2012 at 4:58 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>>> This comes from one of btrfs's project ideas,
>>>> As we defragment files, we break any sharing from other snapshots.
>>>> The balancing code will preserve the sharing, and defrag needs to grow this
>>>> as well.
>>>>
>>>> Now we're able to fill the blank with this patch, in which we make full use of
>>>> backref walking stuff.
>>>>
>>>> Here is the basic idea,
>>>> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
>>>> o  at endio, after we finish updating fs tree, we use backref walking to find
>>>>    all parents of the ranges and re-link them with the new COWed file layout by
>>>>    adding corresponding backrefs.
>>>>
>>>> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
>>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>>
>>> I'm hitting the WARN_ON in record_extent_backrefs() indicating a
>>> problem with the return value from iterate_inodes_from_logical().
> 
> Me too.  It triggers reliably with mount -o autodefrag, and then crashes
> a in the next function ;)
> 
> -chris
> 

Good news, I'm starting hitting the crash (a NULL pointer crash) ;)

thanks,
liubo
