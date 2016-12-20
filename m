Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753271AbcLTQcz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 11:32:55 -0500
Date: Tue, 20 Dec 2016 17:32:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: Fix NULL pointer when receive clone
 operation
Message-ID: <20161220163239.GP3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161215083702.25732-1-quwenruo@cn.fujitsu.com>
 <581c4b0a-c7fa-c07a-f656-ee88343fbe85@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <581c4b0a-c7fa-c07a-f656-ee88343fbe85@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 16, 2016 at 09:37:54AM +0900, Tsutomu Itoh wrote:
> On 2016/12/15 17:37, Qu Wenruo wrote:
> > Regression introduced by:
> > commit a2f7af94abe4a3491ca1280a2ae1d63edc0d62ab
> > Author: Prasanth K S R <prasanth.ksr@dell.com>
> > Date:   Sat Dec 10 19:17:43 2016 +0530
> > 
> >     btrfs-progs: subvol_uuid_search: return error encoded pointer
> > 
> > IS_ERR() will only check if it's an error code, won't check if it's
> > NULL.
> > And for all the caller the commit modifies, it can return NULL and makes
> > cause segfault.
> > 
> > Fix it by introducing new IS_ERR_OR_NULL() macro, and for NULL pointer
> > and needs to return int case, convert NULL pointer to -ENOENT.
> 
> This patch also passed xfstests btrfs/{108,109,117}. Thanks for your work.

Applied, thanks.
