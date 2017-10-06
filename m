Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750849AbdJFQVS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 12:21:18 -0400
Date: Fri, 6 Oct 2017 18:19:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs-progs: check: return value of
 check_extent_refs()
Message-ID: <20171006161934.GU3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
 <20170927063440.25961-2-suy.fnst@cn.fujitsu.com>
 <20171005174625.GM3521@twin.jikos.cz>
 <32020668-72b8-fe0c-cb13-145a46d1cbfe@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <32020668-72b8-fe0c-cb13-145a46d1cbfe@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 06, 2017 at 09:38:05AM +0800, Su Yue wrote:
> 
> 
> On 10/06/2017 01:46 AM, David Sterba wrote:
> > On Wed, Sep 27, 2017 at 02:34:36PM +0800, Su Yue wrote:
> >> In original check mode(without option "--repair"), check_extent_refs()
> >> always returns 0.
> >>
> >> Add a variable @error to record status while checking extents.
> >> At the end of check_extent_refs(), let it return -EIO if @error is
> >> nonzero.
> >>
> >> Example:
> >> $ btrfs check bad-extent-inline-ref-type.raw
> >> Checking filesystem on bad-extent-inline-ref-type.raw
> >> UUID: 1942d6fe-617b-4499-9982-cc8ffae5447f
> >> checking extents
> >> corrupt extent record: key 29360128 169 16384
> >> ref mismatch on [29360128 16384] extent item 0, found 1
> >> Backref 29360128 parent 5 root 5 not found in extent tree
> >> backpointer mismatch on [29360128 16384]
> >> bad extent [29360128, 29376512), type mismatch with chunk
> >> checking free space cache
> >> checking fs roots
> >> checking csums
> >> checking root refs
> >> found 114688 bytes used, no error found
> >> total csum bytes: 0
> >> total tree bytes: 114688
> >> total fs tree bytes: 32768
> >> total extent tree bytes: 16384
> >> btree space waste bytes: 109471
> >> file data blocks allocated: 0
> >>   referenced 0
> >>
> >> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> > 
> > With this patch applied, the test fsck/006 fails, is that intentional?
> > 
> Yes, it's expected. This patch just let btrfs-progs return a correct
> value.

Ok thanks. I'll add a note about that to the changelog, this kind of
information is important when we knowingly break bisectability.
