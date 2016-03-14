Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933964AbcCNMUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 08:20:07 -0400
Date: Mon, 14 Mar 2016 13:19:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] btrfs-progs: Fix a regression that btrfs filesystem
 label doesn't work
Message-ID: <20160314121943.GA18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56E5FF9A.4020609@jp.fujitsu.com>
 <56E602AE.7080203@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E602AE.7080203@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 09:15:42AM +0900, Satoru Takeuchi wrote:
> The number of arguments which is allowed to pass became wrong
> from the following commit.
> 
> commit 176aeca9a148c5e29de0 ("btrfs-progs: add getopt stubs where needed")
> 
> * actual result
> 
>   ===========================================================
>   # ./btrfs prop get /btrfs label
>   label=foo
>   # ./btrfs fi label /btrfs
>   btrfs filesystem label: too few arguments
>   usage: btrfs filesystem label [<device>|<mount_point>] [<newlabel>]
> 
>       Get or change the label of a filesystem
> 
>       With one argument, get the label of filesystem on <device>.
>       If <newlabel> is passed, set the filesystem label to <newlabel>.
> 
>   # ./btrfs fi label /btrfs bar
>   foo
>   # ./btrfs prop get /btrfs label
>   label=foo
>   ===========================================================
> 
> * expected result
> 
>   ===========================================================
>   # ./btrfs prop get /btrfs label
>   label=foo
>   # ./btrfs fi label /btrfs
>   foo
>   # ./btrfs fi label /btrfs bar
>   # ./btrfs prop get /btrfs label
>   label=bar
>   ===========================================================
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Applied, thanks.
