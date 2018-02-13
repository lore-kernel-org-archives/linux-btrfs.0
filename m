Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57856 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932403AbeBMAMd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 19:12:33 -0500
Date: Mon, 12 Feb 2018 16:06:31 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
Message-ID: <20180213000631.GB23045@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
 <7483e29f-9f26-a338-1712-35ef2f718c26@suse.com>
 <20180212141741.GA25827@dhcp-10-159-140-209.vpn.oracle.com>
 <7d4e2901-8330-976b-9791-13b22f75ce96@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7d4e2901-8330-976b-9791-13b22f75ce96@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 07:39:02PM +0200, Nikolay Borisov wrote:
> 
> 
> On 12.02.2018 16:17, Liu Bo wrote:
> > On Tue, Feb 06, 2018 at 11:11:55AM +0200, Nikolay Borisov wrote:
[...]
> >>
> >> Use list_for_each_entry_safe to make it more apparent you are going to
> >> be removing from the list. The code as-is works since you are doing a
> >> break after deleting element from the list but this is somewhat subtle.
> > 
> > To be honest, I don't see much difference.
> > 
> > I think the _safe version is to protect us from some race when others
> > remove objects from list, and write lock is held so we're safe.
> 
> No, the _safe version uses the second argument (n) as the list iterator.
> The non-safe version just uses 'pos', and in case you remove 'pos' from
> the list AND continue iterating you will deref an invalid pointer. So
> _safe is actually really necessary for correctness when you intend to
> remove an entry from a list you are iterating, irrespective of any locks
> you might have.

You're right, I know it takes an extra pointer to store the next
entry, but miss the point when deleting by itself.

Thank you for the clarification.

thanks,
-liubo
