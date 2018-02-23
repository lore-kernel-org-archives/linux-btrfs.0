Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51483 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751733AbeBWXZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 18:25:07 -0500
Date: Sat, 24 Feb 2018 00:22:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 23/27] btrfs-progs: use libbtrfsutil for subvol sync
Message-ID: <20180223232247.GS1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1518720598.git.osandov@fb.com>
 <f39e48b3ed0f860ec47b31fbfe08f6455d6fbaa8.1518720598.git.osandov@fb.com>
 <c706be51-70d3-9b5b-f0b9-79268f9d2960@jp.fujitsu.com>
 <20180223224127.GB7046@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180223224127.GB7046@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 23, 2018 at 02:41:27PM -0800, Omar Sandoval wrote:
> > >  static int cmd_subvol_sync(int argc, char **argv)
> > >  {
> > >  	int fd = -1;
> > > -	int i;
> > >  	int ret = 1;
> > >  	DIR *dirstream = NULL;
> > > -	u64 *ids = NULL;
> > > -	int id_count;
> > > +	uint64_t *ids;
> > 
> > "ids" should be initialized to prevent to be used uninitialized for free()
> > in error path (clang build warning).
> 
> I'm disappointed that GCC didn't also warn here, but thanks, fixed.

It's not reported even with the make W=3 level, gcc version 7.3.0.
