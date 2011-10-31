From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 07/66] btrfs: clear_extent_bit error push-up
Date: Mon, 31 Oct 2011 16:07:54 +0100
Message-ID: <20111031150754.GE19328@twin.jikos.cz>
References: <20111025010236.322699279@suse.com> <20111025010851.368992601@suse.com> <20111026151024.GB5914@twin.jikos.cz> <4EA824D2.6070801@suse.com> <20111027120049.GA19328@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jeff Mahoney <jeffm@suse.com>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111027120049.GA19328@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2011 at 02:00:49PM +0200, David Sterba wrote:
> still crashes in xfstests/113 with the following fixup. so there may be more
> occurences of the ret value clobbering, I closely reviewed only this patch.
> I'll verify with just that on top.

So it did not crash (though I've hit the NULL-deref in
btrfs_print_leaf), but no errors related to clear_extent_bit.


david
