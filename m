Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57981 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932286AbdIFO02 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 10:26:28 -0400
Date: Wed, 6 Sep 2017 16:24:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        jbacik@fb.com, clm@fb.com, dsterba@suse.com
Subject: Re: [PATCH] btrfs: fix NULL pointer dereference from
 free_reloc_roots()
Message-ID: <20170906142459.GP31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <150363811494.24591.5585689547237978902.stgit@naota.dhcp.fujisawa.hgst.com>
 <ee561c2e-b998-a264-3f9b-a36b26a3c626@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ee561c2e-b998-a264-3f9b-a36b26a3c626@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 08:49:11AM +0300, Nikolay Borisov wrote:
> 
> 
> On 25.08.2017 08:15, Naohiro Aota wrote:
> > __del_reloc_root should be called before freeing up reloc_root->node.
> > If not, calling __del_reloc_root() dereference reloc_root->node, causing
> > the system BUG.
> > 
> > Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> 
> This patch should also have:
> 
> Fixes: 6bdf131fac23 ("Btrfs: don't leak reloc root nodes on error")
> Cc: <stable@vger.kernel.org> # 4.9
> 
> With that:
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I'll add the other tags, thanks.
