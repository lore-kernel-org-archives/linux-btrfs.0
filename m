From: David Sterba <dave@jikos.cz>
Subject: Re: Create subvolume from a directory?
Date: Wed, 28 Mar 2012 11:24:55 +0200
Message-ID: <20120328092455.GD11610@twin.jikos.cz>
References: <loom.20120327T190041-268@post.gmane.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120327T190041-268@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2012 at 05:19:06PM +0000, Alex wrote:
> Can I create/convert a existing (btrfs) directory into a subvolume?

For the reference there's an entry at the wiki:

http://btrfs.ipv5.de/index.php?title=UseCases#Can_I_take_a_snapshot_of_a_directory.3F

as noted in the thread, this relies on the unmerged cross-subvolume
reflink patch.


david
