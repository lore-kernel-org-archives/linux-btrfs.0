Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26310 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdFAW70 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 18:59:26 -0400
Date: Thu, 1 Jun 2017 15:57:29 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Ivan Sizov <sivan606@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] add sanity check for extent inline ref type
Message-ID: <20170601225729.GA3279@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <CAMG9ccwjBmP9HKkodwARxQK7AkC68HACMzuT43wX6+gmWVUjbg@mail.gmail.com>
 <20170601173510.GA22952@lim.localdomain>
 <CAMG9ccwxQn172kpUR61hp8OV_H+rRx4BQhRvMpUs4qn4DKic+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMG9ccwxQn172kpUR61hp8OV_H+rRx4BQhRvMpUs4qn4DKic+Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 01, 2017 at 11:26:26PM +0300, Ivan Sizov wrote:
> 2017-06-01 20:35 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
> > After I went through the output of leaf's content, most parts of the
> > leaf is sane except the two corrupted items, it's still not clear to
> > me what caused the corruption, there could be some corner cases that
> > I'm not aware of.
> >
> > If fsck doesn't work for you, then a recovery from backup may be the
> > best option.
> 
> I don't need to run any repair procedures because system is working
> normally. Most likely that corrupted extents belong to files located
> somewhere in /home.
> Do you mean I should run fsck in order to determine which files are
> corrupted? What are proper options to run fsck with?

I see.  Scrub has found that there are some corrupted metadata, if you
want to fix that corrupted thing, fsck may be helpful.  Due to my
test, 'btrfs check /your_disk' fixed my corruption.

With this patch set, at least you won't get a crash when accessing the
corrupted extent inline ref.

-liubo
