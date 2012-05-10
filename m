From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH] Btrfs: use ALIGN macro instead of open-coded expression
Date: Thu, 10 May 2012 09:10:23 +0800
Message-ID: <20120510011023.GF10252@yliu-dev.sh.intel.com>
References: <1336464984-30746-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20120509164549.GM19331@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120509164549.GM19331@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2012 at 06:45:49PM +0200, David Sterba wrote:
> On Tue, May 08, 2012 at 04:16:24PM +0800, Yuanhan Liu wrote:
> > According to section 'Find open-coded helpers or macros' at
> > https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas, here
> > in the patch we use ALIGN macro to do the alignment.
> 
> Well, I wrote this section and some time later also the patches,
> http://www.spinics.net/lists/linux-btrfs/msg12747.html
> 
> but did not update the section with the status reflecting this, sorry
> that you duplicated work.

It's OK. I just didn't find those 'issue' was fixed in mainline, thus I
thought it still exist.

Thanks,
Yuanhan Liu
