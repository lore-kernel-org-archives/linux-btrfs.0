Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49106 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933920AbcJYM3V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 08:29:21 -0400
Date: Tue, 25 Oct 2016 14:29:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v2 2/4] btrfs-progs: volumes: Remove BUG_ON in raid56
 write routine
Message-ID: <20161025122914.GM22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161025021106.30842-1-quwenruo@cn.fujitsu.com>
 <20161025021106.30842-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161025021106.30842-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2016 at 10:11:04AM +0800, Qu Wenruo wrote:
> Remove various BUG_ON in raid56 write routine, including:
> 1) Memory allocation error
>    Old codes allocates memory when code needs new memory in a loop, and
>    catch the error using BUG_ON().
>    New codes allocates memory in a allocation loop first, if any failure
>    is caught, freeing already allocated memories then throw -ENOMEM.
> 
> 2) Write error
>    Change BUG_ON() to correct return value.
> 
> 3) Validation check
>    Same as write error.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> changelog:
> v2:
>   Fix error in calloc usage which leads to double free() on data
>   stripes.

Patch replaced in relevant branches, thanks.
