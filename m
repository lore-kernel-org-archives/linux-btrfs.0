Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:53762 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3HHPB5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 11:01:57 -0400
Message-ID: <5203B2E1.2060101@jan-o-sch.net>
Date: Thu, 08 Aug 2013 17:01:53 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: deal with enomem in the rewind path V3
References: <1375909381-24516-1-git-send-email-jbacik@fusionio.com> <52034A94.9040003@jan-o-sch.net> <20130808142805.GX5284@twin.jikos.cz>
In-Reply-To: <20130808142805.GX5284@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, August 08, 2013 at 16:28 (+0200), David Sterba wrote:
> On Thu, Aug 08, 2013 at 09:36:52AM +0200, Jan Schmidt wrote:
>> Weird patch formatting concerning extent_io.c, I assume there are no changes in
>> extent_buffer_under_io and btrfs_release_extent_buffer_page, you just moved
>> btrfs_clone_extent_buffer, right? Perhaps --patience or --minimal could do
>> better? Otherwise,
> 
> git diff --patience produces identical result for me (1.8.3.1).

Yeah, I expected that after Josef said that he actually moved the other two
functions, so the structure really changed in a way git cannot diff any better.

>> Reviewed-by: Jan Schmidt <list.xfs@jan-o-sch.net>
>                                  ^^^
> xfs? :)

Whoops :-) Replace that by btrfs if you wish.

-Jan
