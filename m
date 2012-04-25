From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Add missing unlocks on error paths
Date: Wed, 25 Apr 2012 23:40:14 +0200
Message-ID: <20120425214014.GM20982@twin.jikos.cz>
References: <1335369891-19137-1-git-send-email-daniel@quora.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335369891-19137-1-git-send-email-daniel@quora.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2012 at 12:04:51AM +0800, Daniel J Blueman wrote:
> Correctly drop locks during error cases.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> ---

fyi, the same patch is already present in for-linus,
871383be592ba7e819d27556591e315a0df38cee
[http://www.spinics.net/lists/linux-btrfs/msg15837.html]

david
