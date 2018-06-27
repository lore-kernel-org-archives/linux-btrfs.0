Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751516AbeF0M6P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 08:58:15 -0400
Date: Wed, 27 Jun 2018 14:58:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: return EUCLEAN if extent_inline_ref type is
 invalid
Message-ID: <20180627125814.GD2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180622075349.17976-1-suy.fnst@cn.fujitsu.com>
 <20180622081801.19891-1-suy.fnst@cn.fujitsu.com>
 <20180622094038.GW24375@twin.jikos.cz>
 <7a864047-c1e8-0044-8660-e3862b5df78d@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7a864047-c1e8-0044-8660-e3862b5df78d@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2018 at 09:28:32AM +0800, Su Yue wrote:
> 
> 
> On 06/22/2018 05:40 PM, David Sterba wrote:
> > On Fri, Jun 22, 2018 at 04:18:01PM +0800, Su Yue wrote:
> >> If type of extent_inline_ref found is not expected, filesystem may have
> >> been corrupted, should return EUCLEAN instead of EINVAL.
> >> No functional changes.
> >>
> >> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> >> ---
> >> Changelog:
> >> v2:
> >>   Add changes in build_backref_tree, get_extent_inline_ref and
> >>     add_inline_refs.
> > 
> > v2 looks good. I saw one implicit check for invalid ref in
> > add_data_references that still returns -EINVAL.
> > 
> > The implicit check is located in relocation.c:3804. I changed
> it in v1 which is not listed in changedlog.
> Did I need to sent v3 to list all functions in commit message?

No, the change is in the patch, I must have overlooked it, sorry. Added
to misc-next now, thanks.
