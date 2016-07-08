Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbcGHPIl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 11:08:41 -0400
Date: Fri, 8 Jul 2016 17:08:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add the error message when open fails
Message-ID: <20160708150857.GM13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201606090123.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20160609131343.GJ3905@twin.jikos.cz>
 <61e21717-f881-0484-2040-8caf73ff3cca@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <61e21717-f881-0484-2040-8caf73ff3cca@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 08:32:12AM +0900, Tsutomu Itoh wrote:
> Hi, David,
> 
> On 2016/06/09 22:13, David Sterba wrote:
> > On Thu, Jun 09, 2016 at 10:23:15AM +0900, Tsutomu Itoh wrote:
> >> When open in btrfs_open_devices failed, only the following message is
> >> displayed. Therefore the user doesn't understand the reason why open
> >> failed.
> >>
> >>   # btrfs check /dev/sdb8
> >>   Couldn't open file system
> >>
> >> This patch adds the error message when open fails.
> >
> > I think the message should be printed by the caller, not by the helper.
> 
> However in this case, error device name is not understood in the caller.

Right, makes more sense to print from within btrfs_open_devices.
Applied.
