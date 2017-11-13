Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46312 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdKMTDG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 14:03:06 -0500
Date: Mon, 13 Nov 2017 11:01:11 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: Jeff Layton <jlayton@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs list corruption and soft lockups while testing writeback
 error handling
Message-ID: <20171113180111.GA20640@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <1494501232.2625.3.camel@redhat.com>
 <1494532377.2771.3.camel@redhat.com>
 <30759db2-127f-a9e6-2c77-5734137ce52c@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <30759db2-127f-a9e6-2c77-5734137ce52c@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 11, 2017 at 03:56:35PM -0400, Chris Mason wrote:
> On 05/11/2017 03:52 PM, Jeff Layton wrote:
> > On Thu, 2017-05-11 at 07:13 -0400, Jeff Layton wrote:
> > > I finally got my writeback error handling test to work on btrfs (thanks,
> > > Chris!), by making the filesystem stripe the data and mirror the
> > > metadata across two devices. The test passes now, but on one run, I got
> > > the following list corruption warning and then a soft lockup (which is
> > > probably fallout from the list corruption).
> > > 
> > > I ran the test several times before and since then without this failure,
> > > so I don't have a clear reproducer. The kernel in this instance is
> > > basically a v4.11 kernel with my pile of writeback error handling
> > > patches on top:
> > > 
> > >     https://urldefense.proofpoint.com/v2/url?u=https-3A__git.samba.org_-3Fp-3Djlayton_linux.git-3Ba-3Dshortlog-3Bh-3Drefs_heads_wberr&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=BXXwaUFQNFNaGGFYHEVlvNBwkrXiIoH7K5iOdR_PvxM&s=xE6pIXeQ1rlaxAV8aTYBSiI06pb3WZoiRJW8Vo1L3NQ&e=
> > > 
> > > It may be that they are a contributing factor, but this smells more like
> > > a bug down in btrfs. Let me know if you need other info:
> 
> [ btrfs inode logging ]
> 
> > (cc'ing Liu Bo since we were discussing this earlier this week)
> > 
> > I can't reproduce this on stock v4.11, so I think this is a bug in my
> > series.
> > 
> > I think this is due to the differences in how errors are being reported
> > from filemap_fdatawait_range now causing some transactions to end up
> > being freed while they're still on the log_ctxs list. I'm working on
> > hunting down the problem now.
> > 
> > Sorry for the noise!
> > 
> 
> There's a list in the inode logging code that we consistently seem to find
> list debugging assertions with.  We've fixed up all the known issues, but I
> wouldn't be surprised if we've got a goto fail in there.
> 
> I'll take a look ;)

FYI, I've nailed this down, and it turns out to be a bug from btrfs side[1].

[1] https://patchwork.kernel.org/patch/10056535/
"Btrfs: fix list_add corruption and soft lockups in fsync"

Thanks,

-liubo
