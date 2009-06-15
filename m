From: Josef Bacik <josef@redhat.com>
Subject: Re: Removal of snapshots (and subvolumes)
Date: Mon, 15 Jun 2009 14:19:18 -0400
Message-ID: <20090615181918.GE3085@localhost.localdomain>
References: <4A367CC6.1000302@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, aaron@merfinllc.com
To: Jan Kiszka <jan.kiszka@siemens.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A367CC6.1000302@siemens.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 15, 2009 at 06:54:30PM +0200, Jan Kiszka wrote:
> Hi,
> 
> obviously btrfs is yet lacking any means to delete snapshots and
> subvolumes, well, at least their names (I read something about deleting
> their content...). We wanted to start playing with circular snapshots
> over btrfs driven by an application, so this limitation is a bit unhandy
> - even if everything is highly experimental here anyway.
> 
> Browsing the archive, I found Aaron's first patches to fill this gap.
> What happened to them? Besides likely a few remaining bugs, the biggest
> seems to have been some lacking references in btrfs' tree roots. Did
> this situation change meanwhile? What is the schedule for this feature?
> If it's just lacking someone to pick up already existing bits and bring
> them in shape, I could offer a hand. Just hacking on btrfs with broader
> scope is currently not possible.
>

Its a little tricky atm, with Yan's new format patches.  The drop snapshots
patch he sent recently will be needed.  You just need to use that to drop the
items in the snapshot root, and then you'll need to add some extra code to
actually remove the root.  I think thats everything.  Thanks,

Josef 
