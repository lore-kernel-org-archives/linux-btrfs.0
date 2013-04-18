Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab3DRQ26 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 12:28:58 -0400
Date: Thu, 18 Apr 2013 18:28:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] Btrfs-progs: enhance 'btrfs subvolume list'
Message-ID: <20130418162853.GJ16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
 <8c3c7c8ec1747e9fe96ccf17ccc2b6669e1d1fb8.1365696891.git.sbehrens@giantdisaster.de>
 <51675C33.30704@cn.fujitsu.com>
 <5167BB75.9080604@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5167BB75.9080604@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 12, 2013 at 09:44:53AM +0200, Stefan Behrens wrote:
> On Fri, 12 Apr 2013 08:58:27 +0800, Wang Shilong wrote:
> >> "btrfs subvolume list" gets a new option "--fields=..." which allows
> >> to specify which pieces of information about subvolumes shall be
> >> printed. This is necessary because this commit also adds all the so
> >> far missing items from the root_item like the received UUID, all
> >> generation values and all time values.
> >>
> >> The parameters to the "--fields" option is a list of items to print:
> >> --fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,
> >>          stime,rtime,path,rootid,parent,topid,all
> > 
> > The new option '--fields' is helpful, however, i am wondering
> > whether we should remove the old options '-g', '-c'...etc. These
> > options has been there for a period of time,some shell script may use
> > it.
> > 
> > IMO, to ensure compatibility, we'd better keep it.
> 
> What do other people on the list think about maintaining compatibility
> in this case?
> 
> IMO it is acceptable to break compatibility for such a change. It would
> confuse everybody who reads the man page that there are 1 1/2 ways to
> configure the printed columns.

Counting those in your patch, there are currently 17 fields to print, I
think that it's impossible to keep sane assignment of single letters to
each field.

I'm for dropping them at the cost of breaking some scripts and introduce
a predefined sets of fields to print based on most common usages.
For example send/recv related, or a very short output with just id,path
etc.

For some period we should add a deprecation warning for the removed
options so it's not completely silent change.


david
