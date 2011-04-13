From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v5 1/8] btrfs: Balance progress monitoring
Date: Wed, 13 Apr 2011 15:34:57 +0200
Message-ID: <20110413133457.GN31675@twin.jikos.cz>
References: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
 <1302469571-12605-2-git-send-email-hugo@carfax.org.uk>
 <20110412171232.GJ31675@twin.jikos.cz>
 <20110412184207.GH5301@carfax.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo-lkml@carfax.org.uk>, chris.mason@oracle.com,
	dave@jikos.cz, lizf@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110412184207.GH5301@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2011 at 07:42:07PM +0100, Hugo Mills wrote:
>    There will be savings in the future, however -- when I add Li's
> suggestion for tracking the number of bytes (in the block groups as a
> whole, and in terms of useful data stored), plus the vaddr of the
> last-moved block group, the size of the btrfs_balance_info struct will
> go up from its current 8 bytes to 48. I've just not quite finished
> that patch yet, and wanted to get the rest of the patches settled
> while I work on the new one...

makes sense, no objections.

david
