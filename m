Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbbDGPET (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 11:04:19 -0400
Date: Tue, 7 Apr 2015 17:04:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs-progs: Doc: Add warning and note on
 btrfs-convert.
Message-ID: <20150407150416.GB25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1428024075-10211-1-git-send-email-quwenruo@cn.fujitsu.com>
 <pan$c078e$9a53acee$d6e24908$3d5c7666@cox.net>
 <551E3C06.9040305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <551E3C06.9040305@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 03, 2015 at 03:06:46PM +0800, Qu Wenruo wrote:
> > Qu Wenruo posted on Fri, 03 Apr 2015 09:21:15 +0800 as excerpted:
> >
> >> +WARNING: If one hopes to rollback to ext2/3/4, he or she should not execute
> >> +*btrfs balance* command on converted btrfs.
> >> +Since it will change the extent layout and make *btrfs-convert* unable to
> >> +rollback.
> >
> > Because "since" is subordinating and the sentence doesn't contain what
> > it is subordinated to as that's explained in the previous sentence,
> > "Since it will..." introduces a sentence fragment.
> Thanks.
> 
> It seems my English is really poor... :(

Do not worry too much, we need both the technical content and the
writing style. As you can see there are people to help, the comments
should not discourage you.  This is similar to the "code" patches, we
do cleanups. Technical writing is specialization on its own, we do not
have to be proficient in everything.
