Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40445 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751830AbdI2Rcj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 13:32:39 -0400
Date: Fri, 29 Sep 2017 19:31:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, quwenruo.btrfs@gmx.com
Subject: Re: [PATCH] btrfs: take the error path out if
 btrfs_attach_transaction() fails
Message-ID: <20170929173103.GS31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170927095052.22663-1-anand.jain@oracle.com>
 <20170927141701.GI31640@twin.jikos.cz>
 <7e4678b8-5aa4-f90a-b633-db77b4199a11@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7e4678b8-5aa4-f90a-b633-db77b4199a11@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 03:13:06PM +0800, Anand Jain wrote:
> > I'd suggest to first get rid of the in-place returns and add necessary
> > labels or separate exit sequences and then address the new error
> > handling.
> 
>    As it goes deeper there are quite a number of things which aren't
>    un-done during fail error return .. adding one more to the list
>    is sb->super_copy updates. With this current design on this function
>    its kind of too difficult to undo and error return. As
>    btrfs_init_new_device() is shared between normal device add and
>    sprout device add. I am mulling on completely removing seed part
>    to outside of the btrfs_init_new_device(). such as ..
>          prepare sprout.
>          ret = btrfs_init_new_device() which is without the seed part
>          if(ret) undo_prepare_sprout
>          else finish sprouting.

Yeah, this would make the code better structured.

>     Also with this I think we would find few duplicate code sections
>     between btrfs_init_new_device() and replace device which will be
>     a nice cleanup as a whole. This is a long term plan, for now
>     I think v4 is good.

Ok, thanks.
