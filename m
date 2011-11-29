From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] fs: push file_update_time into ->page_mkwrite
Date: Tue, 29 Nov 2011 11:08:39 -0500
Message-ID: <20111129160838.GA14560@localhost.localdomain>
References: <1322581259-14409-1-git-send-email-josef@redhat.com>
 <20111129155020.GQ5635@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk,
	hch@infradead.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111129155020.GQ5635@quack.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 04:50:20PM +0100, Jan Kara wrote:
> On Tue 29-11-11 10:40:59, Josef Bacik wrote:
> > The fault code has been calling file_update_time after ->page_mkwrite after it
> > drops the page lock, but this is annoying because this calls mark_inode_dirty
> > which can fail in Btrfs, so we want to be able to do these updates in
> > ->page_mkwrite so we can get an error back to the user.  So get rid of the
> > file_update_time calls in the fault code and push it into everybody who has a
> > ->page_mkwrite.  I didn't do this for ubifs because it appears that ubifs
> > already updates the time itself in ->page_mkwrite, presumebly for the same
> > reasons as btrfs, so I left it as is.  Thanks,
>   But this effectively disables atime updates on mmaped writes for ext2,
> ext3, and similar filesystems which is a no-go IMHO.
>

Heh doh you're right, I have vacation brain.  Thanks,

Josef 
