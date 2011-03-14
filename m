From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFE] Add a new super operation for finding block devices in a
	super
Date: Mon, 14 Mar 2011 13:50:52 -0400
Message-ID: <20110314175051.GB2576@localhost.localdomain>
References: <1300117060-13613-1-git-send-email-josef@redhat.com> <20110314163126.GA13784@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110314163126.GA13784@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2011 at 12:31:26PM -0400, Christoph Hellwig wrote:
> 
> I think there's a better and more efficient way to archive this.
> 
> We already have a bd_super field in struct block_device.  Just
> generalize it, and use it from the freeze code instead of doing the
> get_active_super loop. 
> 

Great I will do that, thanks,

Josef
