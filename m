From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Add a new file op for fsync to give fs's more control
Date: Fri, 15 Apr 2011 15:24:12 -0400
Message-ID: <20110415192412.GA17974@infradead.org>
References: <1302894582-24341-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302894582-24341-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, but this is too ugly to live.  If the reason for this really is
good enough we'll just need to push the filemap_write_and_wait_range
and i_mutex locking into every ->fsync instance.

