Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50175 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752864AbeD2KPp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 06:15:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5D8CBAC6A
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Apr 2018 10:15:44 +0000 (UTC)
Date: Sun, 29 Apr 2018 12:13:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH 3/3] btrfs-progs: build: use m4_flatten instead of
 m4_chomp
Message-ID: <20180429101309.GN21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180427185637.16642-1-jeffm@suse.com>
 <20180427185637.16642-4-jeffm@suse.com>
 <75b17e5e-520f-7c23-b592-047e2b150474@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <75b17e5e-520f-7c23-b592-047e2b150474@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 03:18:17PM -0400, Jeff Mahoney wrote:
> On 4/27/18 2:56 PM, jeffm@suse.com wrote:
> > From: Jeff Mahoney <jeffm@suse.com>
> > 
> > Commit 2e1932e6a38 (btrfs-progs: build: simplify version tracking)
> > started m4_chomp to strip the newlines from the version file.  m4_chomp
> > was introduced in autoconf 2.64 but SLE11 ships with autoconf 2.63.
> > For purposes of just stripping the newline, m4_flatten is sufficient.
> 
> Scratch that.  The previous patch also requires autoconf 2.64.

I wanted to avoid shell tricks, but this should work everywhere:

m4_esyscmd([echo -n $(cat VERSION)])
