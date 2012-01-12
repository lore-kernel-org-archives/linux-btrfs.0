From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: release space on error in page_mkwrite
Date: Thu, 12 Jan 2012 12:59:14 +0100
Message-ID: <20120112115914.GA32405@ds.suse.cz>
References: <1326223218-5342-1-git-send-email-josef@redhat.com>
 <20120111142709.GE21513@ds.suse.cz>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120111142709.GE21513@ds.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 11, 2012 at 03:27:09PM +0100, David Sterba wrote:
> On Tue, Jan 10, 2012 at 02:20:18PM -0500, Josef Bacik wrote:
> WARNING: at fs/btrfs/extent-tree.c:7283 btrfs_free_block_groups+0x25b/0x370
> 
> appeared within minutes.

Sorry, I spoke too soon, the test was running overnight and the warning
is there. I'll send you updated logs and traces.


david
