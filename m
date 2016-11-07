Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42476 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbcKGFg5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 00:36:57 -0500
Date: Sun, 6 Nov 2016 21:36:47 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-ID: <20161107053647.uj7df3ppve4pbfms@merlins.org>
References: <20161107012009.xng7hyhoqwqres3u@merlins.org>
 <8e2407ee-c137-44c3-b9c8-4dec931d6c3a@cn.fujitsu.com>
 <0b840fbb-1a3d-d395-47ad-015e84eac05a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0b840fbb-1a3d-d395-47ad-015e84eac05a@cn.fujitsu.com>
Subject: Re: btrfs support for filesystems >8TB on 32bit architectures
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(sorry for the bad subject line from the mdadm list on the previous mail) 

On Mon, Nov 07, 2016 at 12:18:10PM +0800, Qu Wenruo wrote:
> I'm totally wrong here.
> 
> DirectIO needs the 'buf' parameter of read()/pread() to be 512 bytes
> aligned.
> 
> While we are using a lot of stack memory() and normal malloc()/calloc()
> allocated memory, which are seldom aligned to 512 bytes.
> 
> So to *workaround* the problem in btrfs-progs, we may need to change any
> pread() caller to use aligned memory allocation.
> 
> I really don't think David will accept such huge change for a workdaround...

Thanks for looking into it.
So basically should we just document that btrfs filesystems past 8TB in
size are not supported on 32bit architectures?
(as in you can mount them and use them I believe, but you cannot create,
or repair them)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
