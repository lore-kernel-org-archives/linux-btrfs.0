Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27322 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbbFYNpv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 09:45:51 -0400
Date: Thu, 25 Jun 2015 09:45:45 -0400
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>, Omar Sandoval <osandov@fb.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] btrfs device remove alias
Message-ID: <20150625134545.GC3920@ret.masoncoding.com>
References: <cover.1435161735.git.osandov@fb.com>
 <20150625134151.GH726@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150625134151.GH726@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2015 at 03:41:51PM +0200, David Sterba wrote:
> On Wed, Jun 24, 2015 at 09:09:15AM -0700, Omar Sandoval wrote:
> > The opposite of btrfs device add is btrfs device delete. This really
> > should be btrfs device remove.
> 
> I think people got used to the 'delete' command over time, but for
> convenience I don't mind to add the alias. Also you delete files by 'rm'
> which is short for 'remove' and probably don't mind either.

I do agree that people got used to delete, but its one of those things
that new users are likely to trip over.  And since we're highly unlikely
to ever use 'rm' for something other than deletion, it makes sense to
just alias them.

-chris
