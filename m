From: David Sterba <dave@jikos.cz>
Subject: Re: should I be concerned?
Date: Thu, 6 Oct 2011 01:18:22 +0200
Message-ID: <20111005231821.GA17912@twin.jikos.cz>
References: <CALxYTP46e6XYhk3iB03GmNBm+ixXkmSgn-8TJWbH5Va+O8v9EA@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Doug Hunley <doug.hunley@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALxYTP46e6XYhk3iB03GmNBm+ixXkmSgn-8TJWbH5Va+O8v9EA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 05, 2011 at 06:33:37PM -0400, Doug Hunley wrote:
> Rebooted into kernel 3.0.6 today and noticed this in dmesg:
> btrfs: free space inode generation (0) did not match free space cache
> generation (1385197)
> btrfs: failed to load free space cache for block group 26470252544
> 
> Is this something to be concerned with or no?

AFAIK it's not serious, this means the free space cache will be rebuilt.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
