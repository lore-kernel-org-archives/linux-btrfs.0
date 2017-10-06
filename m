Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752110AbdJFRZ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:25:59 -0400
Date: Fri, 6 Oct 2017 19:24:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: Remove received_uuid during received snapshot
 ro->rw switch
Message-ID: <20171006172415.GW3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171004150039.GE3521@twin.jikos.cz>
 <1507191773-23039-1-git-send-email-nborisov@suse.com>
 <f80cdc51-a077-60fa-01b3-3521c0adfdfb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f80cdc51-a077-60fa-01b3-3521c0adfdfb@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 05, 2017 at 05:03:47PM +0800, Anand Jain wrote:
> On 10/05/2017 04:22 PM, Nikolay Borisov wrote:
> > Currently when a read-only snapshot is received and subsequently its ro property
> > is set to false i.e. switched to rw-mode the received_uuid of that subvol remains
> > intact. However, once the received volume is switched to RW mode we cannot
> > guaranteee that it contains the same data, so it makes sense to remove the
> > received uuid. The presence of the received_uuid can also cause problems when
> > the volume is being send.
> 
> Wonder if this [1] approach was considered
> [1]
>   - set a flag on the subvolume to indicate its dirtied so that 
> received_uuid can be kept forever just in case if user needs it for some 
> reference at a later point of time.

Yeah, we need to be careful here. There are more items related to the
recived subvolume, besides received_uuid there's rtransid and rtime so
they might need to be cleared as well.

I don't remember all the details how the send/receive and uuids
interact. Switching from ro->rw needs to affect the 'received' status,
but I don't know how. The problem is that some information is being lost
although it may be quite important to the user/administrator. In such
cases it would be convenient to request a confirmation via a --force
flag or something like that.
