Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751814AbeBTShF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 13:37:05 -0500
Date: Tue, 20 Feb 2018 19:34:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 02/27] Add libbtrfsutil
Message-ID: <20180220183445.GQ10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1518720598.git.osandov@fb.com>
 <5882a6f0414a436bd7a4cfaae938e451724684ac.1518720598.git.osandov@fb.com>
 <20180220173217.GC22059@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180220173217.GC22059@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 20, 2018 at 10:32:17AM -0700, Liu Bo wrote:
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -43,6 +43,8 @@ libbtrfs.so.0.1
> >  library-test
> >  library-test-static
> >  /fssum
> > +/libbtrfsutil.so*
> > +/libbtrfsutil.a
> 
> .gitignore is not part of btrfs-progs, is it?

It is, since version 0.19 :)
