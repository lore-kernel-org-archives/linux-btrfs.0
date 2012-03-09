From: David Sterba <dave@jikos.cz>
Subject: Re: btrfs_search_slot BUG...
Date: Fri, 9 Mar 2012 15:01:58 +0100
Message-ID: <20120309140158.GK4334@twin.jikos.cz>
References: <CAMVG2suFfpjC_n8SpaDRLAZpWGFAPdoT+ESOkrNuoH0WoH8juQ@mail.gmail.com> <4F598839.5060806@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel J Blueman <daniel@quora.org>,
	Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F598839.5060806@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 09, 2012 at 12:34:01PM +0800, Liu Bo wrote:
> On 03/09/2012 12:25 PM, Daniel J Blueman wrote:
> > When testing out 16KB blocks with direct I/O [1] on 3.3-rc6, we
> > quickly see btrfs_search_slot returning positive numbers, popping an
> > assertion [2].
> > 
> > Are >4KB block sizes known broken for now?
> 
> Yes, exactly, the kernel side is not ready for >4K block size, but AFAIK it _is_ on going.

This is connected rather to PAGE_SIZE and PAGE_CACHE_SIZE, which happens
to be 4k on x86_64, but eg. ia64 or powerpc64 are happy with 64k blocks
(leaf and node).


david
