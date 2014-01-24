Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbaAXOwH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 09:52:07 -0500
Date: Fri, 24 Jan 2014 15:52:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Calvin Walton <mailing-lists@kepstin.ca>
Cc: "G. Michael Carter" <mikey@carterfamily.ca>, linux-btrfs@vger.kernel.org
Subject: Re: Confirmation on how btrfs works with RAID and single.
Message-ID: <20140124145205.GS6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CANjusZdjBTzreOTc3xvNeiu-LOBzbO2kLCOmjn=m19B-76m67w@mail.gmail.com>
 <1390236695.1869.3.camel@sasami.ottawa.blindsidenetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390236695.1869.3.camel@sasami.ottawa.blindsidenetworks.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 20, 2014 at 11:51:35AM -0500, Calvin Walton wrote:
> > Single:  When it writes does it simple fill up one drive then move to
> > the next or does it write in a round robin type fashion?
> 
> I'm not totally sure, this depends on the vagaries of the chunk
> allocator. When writing only new files to an initially blank filesystem,
> I would expect this to be a case; but on a used filesystem you will
> probably get files fragmented over both disks.

The chunks are sorted by remaining free space, descending, so after some
GBs written it will become ~round robin (depending on the device sizes).

The 'fill one device first" is addressed by
"Btrfs: Add linear chunk allocation support"
http://www.spinics.net/lists/linux-btrfs/msg29616.html
