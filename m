Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:35536 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbcKWEV7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 23:21:59 -0500
Received: by mail-pg0-f41.google.com with SMTP id p66so1089712pga.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Nov 2016 20:21:59 -0800 (PST)
Date: Tue, 22 Nov 2016 20:21:56 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/9] btrfs: calculate end of bio offset properly
Message-ID: <20161123042156.GB29697@mew>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-7-git-send-email-hch@lst.de>
 <20161118200438.GF19038@vader.DHCP.thefacebook.com>
 <20161122094240.GA15407@lst.de>
 <20161122185842.GA17735@vader.DHCP.thefacebook.com>
 <d7a2fef2-900b-236d-8de7-b079b24869a5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d7a2fef2-900b-236d-8de7-b079b24869a5@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2016 at 12:21:41PM +0800, Anand Jain wrote:
> 
> 
> > > Can anyone help me on how to get test coverage for the compression
> > > code?
> > 
> > I'm not surprised xfstests missed this one since it's just readahead.
> > You might be able to get better coverage with
> > 
> > export MOUNT_OPTS="-o compress-force"
> 
>  And where the data is /dev/urandom the btrfs compression will
>  bail out, so xfstest cases which uses /dev/urandom won't test
>  the compression code.

Isn't that just with "-o compress"? That's why I recommended "-o
compress-force".

-- 
Omar
