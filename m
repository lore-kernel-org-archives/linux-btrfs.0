From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Prevent btrfsck to run on mounted filesystems
Date: Fri, 30 Oct 2009 01:02:44 -0400
Message-ID: <20091030050243.GA17714@infradead.org>
References: <200910292152.15564.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Andi Drebes <lists-receive@programmierforen.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910292152.15564.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 29, 2009 at 09:52:15PM +0100, Andi Drebes wrote:
> As recently discussed on the list, btrfsck should only be run on unmounted filesystems. This patch adds a short check for the mount status at the beginning of btrfsck. If the FS is mounted, the program aborts showing an error message.

Just open the nodes with O_EXCL and you'll get all the checking for
free.  Also make sure that for a pure, read-only checks instead of a
repair to allow running on at least a read-only mounted filesystem.

