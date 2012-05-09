From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: use ALIGN macro instead of open-coded expression
Date: Wed, 9 May 2012 18:45:49 +0200
Message-ID: <20120509164549.GM19331@twin.jikos.cz>
References: <1336464984-30746-1-git-send-email-yuanhan.liu@linux.intel.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1336464984-30746-1-git-send-email-yuanhan.liu@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2012 at 04:16:24PM +0800, Yuanhan Liu wrote:
> According to section 'Find open-coded helpers or macros' at
> https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas, here
> in the patch we use ALIGN macro to do the alignment.

Well, I wrote this section and some time later also the patches,
http://www.spinics.net/lists/linux-btrfs/msg12747.html

but did not update the section with the status reflecting this, sorry
that you duplicated work.


david
