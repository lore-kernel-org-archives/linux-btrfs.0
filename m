Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932093AbeGBX0y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 19:26:54 -0400
Date: Tue, 3 Jul 2018 01:26:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Steve Leung <sjleung@shaw.ca>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs-progs: Fixes inline ram_bytes related bugs
Message-ID: <20180702232647.GJ3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180606072717.28854-1-wqu@suse.com>
 <d0ab3c91-3f19-49ee-165c-4dd11a74c4de@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d0ab3c91-3f19-49ee-165c-4dd11a74c4de@shaw.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 07, 2018 at 10:37:16PM -0600, Steve Leung wrote:
> On 06/06/2018 01:27 AM, Qu Wenruo wrote:
> > The patchset can be fetched from github (*):
> > https://github.com/adam900710/btrfs-progs/tree/inline_ram_bytes
> > 
> > It's based on David's devel branch, whose HEAD is:
> > commit 0d1c5812e28e286648781c7b35b542311cc01aa4 (david/devel)
> > Author: Matthias Benkard <matthias.benkard@egym.de>
> > Date:   Wed Apr 25 16:34:54 2018 +0200
> > 
> >      btrfs-progs: mkfs: traverse_directory: Reset error code on continue
> > 
> > Reported-by Steve Leung <sjleung@shaw.ca>, his old btrfs (at least
> > offending inodes are from 2014) has inline uncompressed extent, while
> > its ram_bytes mismatch with item size.
> 
> Took a while to run, but:
> 
> Tested-by: Steve Leung <sjleung@shaw.ca>
> 
> Verifying everything against backups now, but things look good so far.

Thank you very much for testing!
