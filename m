Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbaCOSWH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 14:22:07 -0400
Date: Sat, 15 Mar 2014 19:21:48 +0100
From: David Disseldorp <ddiss@suse.de>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Michael Schuerig <michael.lists@schuerig.de>, linux-btrfs@vger.kernel.org
Subject: Re: Snapper on Ubuntu
Message-ID: <20140315192148.35248385@linux-y6zt.site>
In-Reply-To: <53249245.4050007@friedels.name>
References: <53245E22.1060407@friedels.name>
 <12151050.DOANbtdZpp@fuchsia>
 <53249245.4050007@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 15 Mar 2014 18:47:49 +0100
Hendrik Friedel <hendrik@friedels.name> wrote:

> > I think you may have forgotten to specify the config snapper is supposed
> > to use. Try
> >
> > # snapper -c home create
> > # snapper -c Video create  
> 
> Thanks, that was it. I would have expected an Error-Message though...

Snapper uses the "root" config by default. /root snapshots were created
successfully when you ran "snapper create" without specifying an explicit
config.

Cheers, David
