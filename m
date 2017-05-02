Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750888AbdEBQxL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 12:53:11 -0400
Date: Tue, 2 May 2017 18:53:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Roman Mamedov <rm@romanrm.net>
Subject: Re: [PATCH 3/3 v2] Make max_size consistent with nr
Message-ID: <20170502165304.GT23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <004EF35C-BB29-4B53-8BEC-B0DB38F0A301@redhat.com>
 <20170428141640.12429352@natsu>
 <B8A1E13A-A60F-428D-AA1F-71890BD758EE@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B8A1E13A-A60F-428D-AA1F-71890BD758EE@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 11:51:21AM +0200, Christophe de Dinechin wrote:
> Since we memset tmpl, max_size==0. This does not seem consistent with nr = 1.
> In check_extent_refs, we will call:
> 
>   set_extent_dirty(root->fs_info->excluded_extents,
>                    rec->start,
>                    rec->start + rec->max_size - 1);
> 
> This ends up with BUG_ON(end < start) in insert_state.
> 
> Signed-off-by: Christophe de Dinechin <dinechin@redhat.com>

Applied. Thanks for debugging the issue!
