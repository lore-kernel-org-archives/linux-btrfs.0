From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Add missing unlocks on error paths
Date: Thu, 26 Apr 2012 11:08:56 -0400
Message-ID: <20120426150855.GA25603@dhcp231-144.rdu.redhat.com>
References: <1335369891-19137-1-git-send-email-daniel@quora.org>
 <20120425214014.GM20982@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Daniel J Blueman <daniel@quora.org>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120425214014.GM20982@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2012 at 11:40:14PM +0200, David Sterba wrote:
> On Thu, Apr 26, 2012 at 12:04:51AM +0800, Daniel J Blueman wrote:
> > Correctly drop locks during error cases.
> > 
> > Signed-off-by: Daniel J Blueman <daniel@quora.org>
> > ---
> 
> fyi, the same patch is already present in for-linus,
> 871383be592ba7e819d27556591e315a0df38cee
> [http://www.spinics.net/lists/linux-btrfs/msg15837.html]
> 

Hrm weird I didn't have that in btrfs-next.  Thanks,

Josef
