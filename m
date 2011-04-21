From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: remove trans and root argument from
 fixup_low_keys()
Date: Thu, 21 Apr 2011 12:59:32 +0200
Message-ID: <20110421105932.GB31675@twin.jikos.cz>
References: <201104210954.AA00015@T-ITOH1.jp.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201104210954.AA00015@T-ITOH1.jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Apr 21, 2011 at 06:54:45PM +0900, Tsutomu Itoh wrote:
> 'trans' and 'root' argument not used in fixup_low_keys() are deleted.
> And, the argument that became unnecessary is deleted about the caller
> of fixup_low_keys().

heh, coincidence or synchronicity, I've spent some time yesterday fixing
the same problems. There are tons of unused arguments all over the
place.  I have a few patches already, but still not removed all. I'll
send them out today, so you can have a look and to not duplicate work.


dave
