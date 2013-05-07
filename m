Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41008 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3EGXfX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 19:35:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZrPm-00014b-FL
	for linux-btrfs@vger.kernel.org; Wed, 08 May 2013 01:35:22 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 01:35:22 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 01:35:22 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Possible to deduplicate read-only snapshots for space-efficient
 backups
Date: Tue, 7 May 2013 23:35:06 +0000 (UTC)
Message-ID: <kmc33a$all$3@ger.gmane.org>
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx> <km5ksq$p15$1@ger.gmane.org>
	<64hi5a-9rq.ln1@hurikhan.ath.cx> <kmbtvb$all$1@ger.gmane.org>
	<9tdo5a-hde.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 08 May 2013 01:04:38 +0200, Kai Krakow wrote:
> Gabriel de Perthuis <g2p.code@gmail.com> schrieb:
>> It sounds simple, and was sort-of prompted by the new syscall taking
>> short ranges, but it is tricky figuring out a sane heuristic (when to
>> hash, when to bail, when to submit without comparing, what should be the
>> source in the last case), and it's not something I have an immediate
>> need for.  It is also possible to use 9p (with standard cow and/or
>> small-file dedup) and trade a bit of configuration for much more
>> space-efficient VMs.
>> 
>> Finer-grained tracking of which ranges have changed, and maybe some
>> caching of range hashes, would be a good first step before doing any
>> crazy large-file heuristics.  The hash caching would actually benefit
>> all use cases.
> 
> Looking back to good old peer-2-peer days (I think we all got in touch with 
> that the one or the other way), one title pops back into my mind: tiger-
> tree-hash...
> 
> I'm not really into it, but would it be possible to use tiger-tree-hashes to 
> find identical blocks? Even accross different sized files...

Possible, but bedup is all about doing as little io as it can get away
with, doing streaming reads only when it has sampled that the files are
likely duplicates and not spending a ton of disk space for indexing.

Hashing everything in the hope that there are identical blocks at
unrelated places on the disk is a much more resource-intensive approach;
Liu Bo is working on that, following ZFS's design choices.


