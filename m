Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.workshopit.co.uk ([93.191.37.100]:35283 "EHLO
	mx1.workshopit.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2JSIiW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 04:38:22 -0400
Date: Fri, 19 Oct 2012 09:37:52 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Anand jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] filter snapshot(s) by its parent uuid
Message-ID: <20121019083752.GA19887@campbell-lange.net>
References: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
 <50810363.1090304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50810363.1090304@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/10/12, Miao Xie (miaox@cn.fujitsu.com) wrote:
> On fri, 19 Oct 2012 14:23:53 +0800, Anand jain wrote:
> > From: Anand Jain <anand.jain@oracle.com>
> > 
> > This set of patch will make
> > btrfs su list -s <subvol>
> > to list only snapshot(s) of the given subvol.
> > 
> > before:
> > btrfs su list -s /btrfs/sv1
> > <nothing>
...
> > with this patch:
> > btrfs su list -s /btrfs/sv1
> > ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
> > ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3
> 
> Though the function implemented by your patch is very useful, you change the semantic of "-s",
> I think it is not allowed, or the programs that use "btrfs us list -s" may fail.

>From my perspective as a user I would be grateful if the following changes in
syntax for listing subvolumes could be considered:

In addition to 

    btrfs subvolume list [-apurts] [-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>
    btrfs su list [-apurts] [-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>
        List subvolumes (and snapshots)
    (and Anand's patch to allow <path>/<subpath>)

I believe the following shortcuts may be useful

    btrfs subvolumes [-apurts] [-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>[</subpath>]
    btrfs sl [-apurts] [-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>[</subpath>]

Although from a technical perspective 'subvolume list' may be logical, listing
subvolumes (plural) seems like a different sort of operation to those relating
to a subvolume (singular) for create/alter/show/delete/snapshot operations.

-- 
Rory Campbell-Lange
rory@campbell-lange.net
