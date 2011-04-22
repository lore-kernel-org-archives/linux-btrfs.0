From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: check return value of kmalloc()
Date: Fri, 22 Apr 2011 14:02:54 +0200
Message-ID: <20110422120254.GU31675@twin.jikos.cz>
References: <201104190527.AA00014@T-ITOH1.jp.fujitsu.com>
 <20110419111240.GV31675@twin.jikos.cz>
 <4DAE2E12.7060002@jp.fujitsu.com>
 <20110421121810.GC31675@twin.jikos.cz>
 <4DB0D882.4010207@jp.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB0D882.4010207@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 22, 2011 at 10:23:14AM +0900, Tsutomu Itoh wrote:
> But, reading code again, I noticed nobody use relocate_one_extent() now. ;-)
> However, because there is a possibility to be going to be used in the future,
> I'll add the check of 'new_extents' for the readability.

vim hilight confused me, but the function is inside a large #if 0 block
already, I think we do not need to fix this kmalloc anymore. sorry for not
pointing it out.

the #if0 comes from commit 5d4f98a28c7d334091c1b7744f48a1acdd2a4ae0
dated back to  Jun 10 10:45:14 2009 -0400
Btrfs: Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)

big changeset, disk format change, it's quite understandable that the
autors wanted to keep the previous code in place for some time, but it's
not needed anymore.


david
