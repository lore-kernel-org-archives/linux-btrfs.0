Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41293 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751986AbcKRS2e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 13:28:34 -0500
Date: Fri, 18 Nov 2016 19:28:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: test: expand size of test device of
 fsck-tests 013
Message-ID: <20161118182829.GE12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201611180547.AA00018@WIN-5MHF4RKU941.jp.fujitsu.com>
 <965496ad-0b2c-31af-2de5-e47bd3c7d586@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <965496ad-0b2c-31af-2de5-e47bd3c7d586@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2016 at 02:36:28PM +0800, Qu Wenruo wrote:
> 
> 
> On 11/18/2016 01:47 PM, Tsutomu Itoh wrote:
> > In my test environment, size of /lib/modules/`uname -r`/* is
> > larger than 1GB, so test data can not copy to testdev.
> > Therefore we need expand the size of testdev.
> 
> IMHO the correct fix is to enhance populate_fs() to fill the fs into a 
> given size, other than using the unreliable copy.

Yeah that would be better, the contents of the modules dir could be
anything, but was enough to use for initial testing.
