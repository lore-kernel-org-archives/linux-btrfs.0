Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58993 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752738AbeBER5Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:57:16 -0500
Date: Mon, 5 Feb 2018 18:55:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Howard McLauchlan <hmclauchlan@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Omar Sandoval <osandov@osandov.com>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v3] btrfs: print error if primary super block write fails
Message-ID: <20180205175501.GI18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180202190901.10988-1-hmclauchlan@fb.com>
 <bc22e369-9f13-348b-0227-7822f8660752@oracle.com>
 <3739e239-ab36-d08c-d386-05dc04a3ad18@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <3739e239-ab36-d08c-d386-05dc04a3ad18@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 05, 2018 at 02:45:21PM +0800, Anand Jain wrote:
> On 02/05/2018 02:38 PM, Anand Jain wrote:
> > On 02/03/2018 03:09 AM, Howard McLauchlan wrote:
> >> Presently, failing a primary super block write but succeeding in at
> >> least one super block write in general will appear to users as if
> >> nothing important went wrong.
> > 
> >> However, upon unmounting and re-mounting,
> >> the file system will be in a rolled back state.
> > 
> > Right.! In case of non-datasync-IO, or where applications depend on the
> > transcation_commit() to confirm the IO.
> > 
> > David, Qu,
> > 
> >   In this context (single disk btrfs, the write to primary SB has
> >   been failing but read is fine), if a system is rebooted and continues
> >   the production the data loss is eminent!!!. btrfs_err() won't help to
> >   avoid the data loss nor we could blame the user for not taking any
> >   action on the btrfs_err().
> 
>   I am wrong. I missed the return -1 which this patch adds. Which
>   means it is choice a. as below. But IMO better would have been
>   choice b. though.

I'm concerned about the cases where automatically mounting from the 2nd
superblock would make thigs worse, and IIRC there are not enough data to
decide in the mount callback.
