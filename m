Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750769AbdEBQqv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 12:46:51 -0400
Date: Tue, 2 May 2017 18:46:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Roman Mamedov <rm@romanrm.net>
Subject: Re: [PATCH 2/3 v2] Prevent attempt to insert extent record with
 max_size==0
Message-ID: <20170502164644.GS23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <004EF35C-BB29-4B53-8BEC-B0DB38F0A301@redhat.com>
 <20170428141640.12429352@natsu>
 <74CAC383-4C3A-4C68-9B56-2AB28947E3E3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <74CAC383-4C3A-4C68-9B56-2AB28947E3E3@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 11:50:23AM +0200, Christophe de Dinechin wrote:
> When this happens, we will trip a BUG_ON(end < start) in insert_state
> because in check_extent_refs, we use this max_size expecting it's not zero:
> 
>   set_extent_dirty(root->fs_info->excluded_extents,
>                    rec->start,
>                    rec->start + rec->max_size - 1);
> 
> See https://bugzilla.redhat.com/show_bug.cgi?id=1435567
> for an example where this scenario occurs.
> 
> Signed-off-by: Christophe de Dinechin <dinechin@redhat.com>

Applied, thanks.
