Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31285 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760149Ab3DJOOS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 10:14:18 -0400
Date: Wed, 10 Apr 2013 22:14:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marek Otahal <markotahal@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: online data deduplication
Message-ID: <20130410141434.GA11394@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
 <1365340369-23537-2-git-send-email-bo.li.liu@oracle.com>
 <2033709.8dWmigpxlX@beruska>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2033709.8dWmigpxlX@beruska>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 10, 2013 at 02:05:32PM +0200, Marek Otahal wrote:
> Hello, 
> this is awesome news! thank you for working on dedup. 

Hi,

Your previous thread floating on the LIST did give me some light, thanks :)

> 
> I have some questions about the dedup approach in regards to other layers/features. 
> 
> 1/ How will the snapshots be handled? 
> 
> Whether data would be dedup-ed between snapshots (potentially big saved-space ratio), or would snapshots be considered isolated? Best, if this could be set by the user. My concern is about being error-prone, where with deduping snapshots, actually only 1 copy of the data would exist and a corruption would damage it as well as all snapshots. Or is this not a problem and we say "safety" is handled by RAID? 

I don't think that snapshot should be responsible on data security, even without
dedup, snapshot's files can still share the same disk space/extent with the
source.

So I won't treat dedup on snapshot as a special case.

> 
> 2/ Order of dedup/compression? 
> 
> What would be done first, compress a file and then compare blocks for duplicates, or the other way around? 
> 
> Dedup 1st would save some compression work:
> file's block 0000000000 -> hash -> isDup? (if no)-> compress (10x0) -> write
> but proble is written data size is unknown (it's not the 1 block at start)
> 
> Other way, compress first, would waste compression cpu-operations on duplicate blocks, but would yield reduced dedup-related metadata usage, as 1 million of zeros would be compressed to a single block and that one only is compared/written. Usefullness here depends on the compression ratio of the file. 
> 
> I'm not sure which approach here would be better? 
> 

In my opinion, dedup is a special kind of compression, it's not worth doing
dedup on compressed data as I want to keep this feature to be simple.

I prefer to dedup first rather than compression(but I could be wrong).

thanks,
liubo

> 
> 
> 
> Thank you for your time and explanation. 
> Best wishes, Mark
>    
> On Sunday 07 April 2013 21:12:48 Liu Bo wrote:
> > (NOTE: This leads to a FORMAT CHANGE, DO NOT use it on real data.)
> > 
> > This introduce the online data deduplication feature for btrfs.
> > 
> > (1) WHY do we need deduplication?
> >     To improve our storage effiency.
> > 
> > (2) WHAT is deduplication?
> >     Two key ways for practical deduplication implementations,
> >     *  When the data is deduplicated
> >        (inband vs background)
> >     *  The granularity of the deduplication.
> >        (block level vs file level)
> > 
> >     For btrfs, we choose
> >     *  inband(synchronous)
> >     *  block level
> > 
> >     We choose them because of the same reason as how zfs does.
> >     a)  To get an immediate benefit.
> >     b)  To remove redundant parts within a file.
> > 
> >     So we have an inband, block level data deduplication here.
> > 
> > (3) HOW does deduplication works?
> >     This makes full use of file extent back reference, the same way as
> >     IOCTL_CLONE, which lets us easily store multiple copies of a set of
> >     data as a single copy along with an index of references to the copy.
> > 
> >     Here we have
> >     a)  a new dedicated tree(DEDUP tree) and
> >     b)  a new key(BTRFS_DEDUP_ITEM_KEY), which consists of
> >         (stop 64bits of hash, type, disk offset),
> >         *  stop 64bits of hash
> >            It comes from sha256, which is very helpful on avoiding collision.
> >            And we take the stop 64bits as the index.
> >         *  disk offset
> >            It helps to find where the data is stored.
> > 
> >     So the whole deduplication process works as,
> >     1) write something,
> >     2) calculate the hash of this "something",
> >     3) try to find the match of hash value by searching DEDUP keys in
> >        a dedicated tree, DEDUP tree.
> >     4) if found, skip real IO and link to the existing copy
> >        if not, do real IO and insert a DEDUP key to the DEDUP tree.
> > 
> >     For now, we limit the deduplication unit to PAGESIZE, 4096, and we're
> >     going to increase this unit dynamically in the future.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> -- 
> 
> Marek Otahal :o)
