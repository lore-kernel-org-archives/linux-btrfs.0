Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbcAOMy3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 07:54:29 -0500
Date: Fri, 15 Jan 2016 13:54:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs pre-release 4.4-rc1
Message-ID: <20160115125424.GE4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160114124748.GV4227@suse.cz>
 <5697A734.1000700@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5697A734.1000700@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 02:48:36PM +0100, Holger Hoffstätte wrote:
> On 01/14/16 13:47, David Sterba wrote:
> [..]
> > * free space tree (aka space_cache=v2, kernel 4.5+)
> 
> I'd like to suggest to maybe add a BIG WARNING to the release notes that
> enabling the fst will currently prevent btrfsck from fixing a filesystem,
> due to the incompatible feature flag.

Thanks for the notice.  As the free-space-tree patches are not in any
released kernel, this should affect only developers. Btrfs-progs 4.5
is supposed to work with f-s-t.
