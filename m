Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbaEBNPV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 09:15:21 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5A9A5AC64
	for <linux-btrfs@vger.kernel.org>; Fri,  2 May 2014 13:15:20 +0000 (UTC)
Date: Fri, 2 May 2014 15:15:20 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
Message-ID: <20140502131520.GN5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1398786620.git.dsterba@suse.cz>
 <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz>
 <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com>
 <5360E0EF.8030109@libero.it>
 <20140430121140.GI5988@twin.jikos.cz>
 <5360FB26.9090009@kingswood-consulting.co.uk>
 <20140430133715.GA7571@yadt.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140430133715.GA7571@yadt.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 30, 2014 at 02:37:16PM +0100, David Taylor wrote:
> It makes more sense to me than 'Occupied' and seems cleaner than
> 'Resized To'.  It sort of mirrors how LVM describes PV / VG / LV
> sizes, too.

Do you have a concrete example how we could map the btrfs sizes based on
LVM?
