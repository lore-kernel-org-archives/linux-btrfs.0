Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40355 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754017AbdKMRPW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 12:15:22 -0500
Date: Mon, 13 Nov 2017 18:13:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: introduce device flags
Message-ID: <20171113171328.GB28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-2-bo.li.liu@oracle.com>
 <20171106164025.GO28789@twin.jikos.cz>
 <20171108194612.GA14443@dhcp-10-11-181-32.int.fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171108194612.GA14443@dhcp-10-11-181-32.int.fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 08, 2017 at 11:46:13AM -0800, Liu Bo wrote:
> On Mon, Nov 06, 2017 at 05:40:25PM +0100, David Sterba wrote:
> > > +	Faulty,		/* device is known to have a fault */
> > > +	In_sync,	/* device is in_sync with rest of array */
> > Enums usually are all caps, and with some prefix.
> Well, copied from md... I'll make it all caps, but no prefix name
> seems better to me.

There are 19 .c files including volumes.h, this needs a prefix. We
should keep the naming consistent within btrfs, the references to MD can
be put to a comment.
