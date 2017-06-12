Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751494AbdFLNKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 09:10:45 -0400
Date: Mon, 12 Jun 2017 15:09:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/8] btrfs: remove redundant parameters from
 btrfs_bio_alloc
Message-ID: <20170612130940.GI25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496422340.git.dsterba@suse.com>
 <174c51230cae682e9f6c2c237833da89a1d2b6ab.1496422340.git.dsterba@suse.com>
 <14e19611-b629-a909-20c9-9309e0425368@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <14e19611-b629-a909-20c9-9309e0425368@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 03:40:16PM +0800, Anand Jain wrote:
> 
> 
> On 06/03/17 00:58, David Sterba wrote:
> > All callers pass gfp_flags=GFP_NOFS and nr_vecs=BIO_MAX_PAGES.
> 
>   The line (in the other thread) mentioning the reason to remove
>    __GFP_HIGH can go into the commit log here.

Makes sense, patch updated.
