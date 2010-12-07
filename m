From: hch <hch@lst.de>
Subject: Re: What to do about subvolumes?
Date: Tue, 7 Dec 2010 17:52:13 +0100
Message-ID: <20101207165212.GC21375@lst.de>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101203214526.GA4508@localhost.localdomain> <20101203222756.GF23339@dastard> <1291415351-sup-4820@think> <20101203224525.GC12491@pad.home.fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: "J. Bruce Fields" <bfields@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101203224525.GC12491@pad.home.fieldses.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 03, 2010 at 05:45:26PM -0500, J. Bruce Fields wrote:
> We're using statfs64.fs_fsid for this; I believe that's both stable
> across reboots and distinguishes between subvolumes, so that's OK.

It's a field that doesn't have any useful specification and basically
contains random garbage that a filesystem put into it.  Using it is a
very bad idea.

