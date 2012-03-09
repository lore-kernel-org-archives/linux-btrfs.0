From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: set page->private to the eb
Date: Fri, 9 Mar 2012 14:43:48 +0100
Message-ID: <20120309134348.GJ4334@twin.jikos.cz>
References: <20120308183659.GA2648@dhcp231-144.rdu.redhat.com> <4F595C6C.9080706@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F595C6C.9080706@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 09, 2012 at 09:27:08AM +0800, Liu Bo wrote:
> This is not against the normal branch, so we must inform people that. :)
> 
> Have a quick look, and I guess it is for "Btrfs: allow metadata blocks
> larger than the page size", isn't it?

yes it is.


david
