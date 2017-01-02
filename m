Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755509AbdABRVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jan 2017 12:21:45 -0500
Date: Mon, 2 Jan 2017 18:21:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Mason <clm@fb.com>, dsterba@suse.cz,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, bo.li.liu@oracle.com,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs: make max inline data can be equal to sectorsize
Message-ID: <20170102172128.GL12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
 <20161111202210.GB30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
 <1bbc9b5f-9bdb-d8b6-bbd5-7718ea33dcef@cn.fujitsu.com>
 <20161116161023.GU12522@twin.jikos.cz>
 <147397a2-0401-82c2-069b-ce21e2d07484@fb.com>
 <20161119082702.GV21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161119082702.GV21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 19, 2016 at 03:27:02AM -0500, Zygo Blaxell wrote:
> On Fri, Nov 18, 2016 at 03:58:06PM -0500, Chris Mason wrote:
> > 
> > 
> > On 11/16/2016 11:10 AM, David Sterba wrote:
> > >On Mon, Nov 14, 2016 at 09:55:34AM +0800, Qu Wenruo wrote:
> > >>At 11/12/2016 04:22 AM, Liu Bo wrote:
> > >>>On Tue, Oct 11, 2016 at 02:47:42PM +0800, Wang Xiaoguang wrote:
> > >>>>If we use mount option "-o max_inline=sectorsize", say 4096, indeed
> > >>>>even for a fresh fs, say nodesize is 16k, we can not make the first
> > >>>>4k data completely inline, I found this conditon causing this issue:
> > >>>>  !compressed_size && (actual_end & (root->sectorsize - 1)) == 0
> > >>>>
> > >>>>If it retuns true, we'll not make data inline. For 4k sectorsize,
> > >>>>0~4094 dara range, we can make it inline, but 0~4095, it can not.
> > >>>>I don't think this limition is useful, so here remove it which will
> > >>>>make max inline data can be equal to sectorsize.
> > >>>
> > >>>It's difficult to tell whether we need this, I'm not a big fan of using
> > >>>max_inline size more than the default size 2048, given that most reports
> > >>>about ENOSPC is due to metadata and inline may make it worse.
> > >>
> > >>IMHO if we can use inline data extents to trigger ENOSPC more easily,
> > >>then we should allow it to dig the problem further.
> > >>
> > >>Just ignoring it because it may cause more bug will not solve the real
> > >>problem anyway.
> > >
> > >Not allowing the full 4k value as max_inline looks artificial to me.
> > >We've removed other similar limitation in the past so I'd tend to agree
> > >to do the same here. There's no significant use for it as far as I can
> > >tell, if you want to exhaust metadata, the difference to max_inline=4095
> > >would be really tiny in the end. So, I'm okay with merging it. If
> > >anybody feels like adding his reviewed-by, please do so.
> > 
> > The check is there because in practice it doesn't make sense to inline an
> > extent if it fits perfectly in a data block.  You could argue its saving
> > seeks, but we're also adding seeks by spreading out the metadata in general.
> > So, I'd want to see benchmarks before deciding.
> 
> Does that limit kick in before or after compression?  A compressed extent
> could easily have 4096 bytes of data in 200 bytes.  If a filesystem
> contained a whole lot of exactly-4096-byte compressible files that extra
> byte might be worth something.

A 4k file that compresses to a small number of bytes will be inlined.
The exact constraints are:
 * file size < sectorsize,
 * compressed result <= inline limit (either in the leaf space or max_inline).
