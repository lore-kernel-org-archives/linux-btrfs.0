From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFE] Add a new super operation for finding block devices in a
 super
Date: Mon, 14 Mar 2011 12:31:26 -0400
Message-ID: <20110314163126.GA13784@infradead.org>
References: <1300117060-13613-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	viro@ZenIV.linux.org.uk, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1300117060-13613-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


I think there's a better and more efficient way to archive this.

We already have a bd_super field in struct block_device.  Just
generalize it, and use it from the freeze code instead of doing the
get_active_super loop. 

