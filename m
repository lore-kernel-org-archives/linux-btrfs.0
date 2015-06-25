Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbbFYPbL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 11:31:11 -0400
Date: Thu, 25 Jun 2015 17:31:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Facebook <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: csum: Introduce partial csum for tree block.
Message-ID: <20150625153109.GJ726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
 <557B076B.7050500@fb.com>
 <557E86A9.8040207@cn.fujitsu.com>
 <20150615131507.GL6761@twin.jikos.cz>
 <557F7A5F.5010206@cn.fujitsu.com>
 <557F8C78.7080304@cn.fujitsu.com>
 <55822008.1090305@cn.fujitsu.com>
 <1434643066.28534.0@mail.thefacebook.com>
 <20150618170632.GI6761@suse.cz>
 <55836FB3.1060704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55836FB3.1060704@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 19, 2015 at 09:26:11AM +0800, Qu Wenruo wrote:
> > I agree with that. I'm still not convinced that adding all the kernel
> > code to repair the data is justified, compared to the block-level
> > redundancy alternatives.
> 
> Totally agree with this.
> That's why we have support for RAID1/5/6/10.
> 
> I also hate to add complexity to kernel codes, especially when the scrub 
> codes are already quite complex.
> 
> But in fact, my teammate Zhao Lei is already doing some work to make 
> scrub codes clean and neat.

Doing cleanups is a good thing regardless of new features, please don't
hesitate to post them even if we do not agree to implement the partial
csum/repair.

I'm not against adding the partial csums & repair, but at the moment I'm
not convinced.
