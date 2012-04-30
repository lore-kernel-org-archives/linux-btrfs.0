From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] [PATCH 1/2] fs: introduce inode operation ->update_time
Date: Mon, 30 Apr 2012 11:21:47 -0400
Message-ID: <20120430152147.GA20554@infradead.org>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332771031-3337-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 26, 2012 at 10:10:30AM -0400, Josef Bacik wrote:
> Btrfs has to make sure we have space to allocate new blocks in order to modify
> the inode, so updating time can fail.  We've gotten around this by having our
> own file_update_time but this is kind of a pain, and Christoph has indicated he
> would like to make xfs do something different with atime updates.  So introduce
> ->update_time, where we will deal with i_version an a/m/c time updates and
> indicate which changes need to be made.  The normal version just does what it
> has always done, updates the time and marks the inode dirty, and then
> filesystems can choose to do something different.
> 
> I've gone through all of the users of file_update_time and made them check for
> errors with the exception of the fault code since it's complicated and I wasn't
> quite sure what to do there, also Jan is going to be pushing the file time
> updates into page_mkwrite for those who have it so that should satisfy btrfs and
> make it not a big deal to check the file_update_time() return code in the
> generic fault path. Thanks,

Any reason that atime updates ignore the return value?

Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
