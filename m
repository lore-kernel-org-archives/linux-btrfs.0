Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54725 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751305AbdHQL6b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 07:58:31 -0400
Date: Thu, 17 Aug 2017 13:57:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: convert enum btrfs_compression_type to define
Message-ID: <20170817115706.GS2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170813040244.18841-1-anand.jain@oracle.com>
 <20170813040244.18841-3-anand.jain@oracle.com>
 <20170816135941.GE2866@twin.jikos.cz>
 <6117a0fa-b540-c31f-af10-805fce5b7cfc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6117a0fa-b540-c31f-af10-805fce5b7cfc@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 17, 2017 at 04:33:41AM +0800, Anand Jain wrote:
> 
> 
> On 08/16/2017 09:59 PM, David Sterba wrote:
> > On Sun, Aug 13, 2017 at 12:02:42PM +0800, Anand Jain wrote:
> >> There isn't a huge list to manage the types, which can be managed
> >> with defines. It helps to easily print the types in tracing as well.
> > 
> > We use enums in a lot of places, I'd rather keep it as it is.
> 
>   This patch converts all of them, and it was at only one place.

Yeah, but I mean the enum vs define style of constant definition.

>   I hope I didn't miss any. Further the next patch 3/4 needs it
>   to be define instead of enums, handling enums in the tracing
>   isn't as easy as define.

Interesting, in what way are defines better use in tracepoints? I see
eg. show_flush_state using enum btrfs_flush_state in btrfs_flush_space,
the same pattern applies to patch 3/4.
