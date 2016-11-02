Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48945 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751111AbcKBMFn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 08:05:43 -0400
Date: Wed, 2 Nov 2016 13:05:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: send: fix handling of multiple
 snapshots (-p option)
Message-ID: <20161102120540.GC12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201610190235.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20161028151014.GI12522@twin.jikos.cz>
 <428f2f2b-39d3-8dc9-705c-a3021a040f06@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <428f2f2b-39d3-8dc9-705c-a3021a040f06@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 02, 2016 at 10:11:55AM +0900, Tsutomu Itoh wrote:
> > I'm not sure it's fixed, I wrote a simple test, attached, that triggers
> > the bug even with the patch applied.
> 
> In the attached script,
> 
>    run_check $SUDO_HELPER btrfs send -f "$here"/send.stream -p subv-snap1 subv-snap2 subv-snap3
> 
> I think that 'btrfs' is a mistake of '$TOP/btrfs'.

Oh right, with the fix the test passes.
