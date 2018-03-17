Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from manchmal.in-ulm.de ([217.10.9.201]:53946 "EHLO
        manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752685AbeCQReS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Mar 2018 13:34:18 -0400
Date: Sat, 17 Mar 2018 18:27:15 +0100
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Liu Bo <bo.li.liu@oracle.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4.14 024/110] btrfs: use proper endianness accessors for
 super_copy
Message-ID: <1521305582@msgid.manchmal.in-ulm.de>
References: <20180307191039.748351103@linuxfoundation.org>
 <20180307191042.810088712@linuxfoundation.org>
 <1521139304@msgid.manchmal.in-ulm.de>
 <20180316123049.GC25079@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180316123049.GC25079@kroah.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greg Kroah-Hartman wrote...

> On Thu, Mar 15, 2018 at 07:55:42PM +0100, Christoph Biedl wrote:

> > > commit 3c181c12c431fe33b669410d663beb9cceefcd1b upstream.

> > On big-endian systems, this change intruduces severe corruption,
> > resulting in complete loss of the data on the used block device.

> That sucks.  Can you test Linus's tree to verify the problem is there?
> I'll gladly revert this if Linus's tree also gets the revert, I don't
> want you to hit this when you upgrade to a newer kernel.

Confirmed: The problem is, err ... was in Linus' tree as well. The
rather recent commit 8f5fd927c3a7 reverted the change, after that
everything is as expected again.

Looking at the original commit, I don't have a clue why things go wrong
so horribly - otherwise don't be afraid of my data. I took this as a
chance to verify my data recovery procedure, with success.

    Christoph
