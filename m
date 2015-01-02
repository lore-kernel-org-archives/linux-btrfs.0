Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbbABQMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Jan 2015 11:12:06 -0500
Date: Fri, 2 Jan 2015 17:12:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, dsterba@suse.cz,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: [PATCH v3] btrfs-progs: Documentation: add T/P/E description for
 resize cmd
Message-ID: <20150102161204.GB6114@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141229160712.GK6490@twin.jikos.cz>
 <1419904337-9945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <CAJCQCtSeguD-oC9ikBc-Mn6_xeu2f-EbfLSFLpSOKgVsEs-T5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSeguD-oC9ikBc-Mn6_xeu2f-EbfLSFLpSOKgVsEs-T5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 01, 2015 at 08:27:55PM -0700, Chris Murphy wrote:
> Small problem with the rendering of this commit
> d4ef1a06f8be623ae94e4d498c306e8dd1605bef, when I use 'man btrfs
> filesystem' the above portion looks like this:
> 
>  'K', 'M', 'G', 'T', 'P', or 'E\',
> 
> I'm not sure why there's a trailing slash after the E.

Me neither, but it looks like a bug in the asciidoc processing, ends up
in the intermediate xml output. I'll probably drop/change the quoting.

> Separately, for -t option, it reads:
> For <start>, <len>, <size> it is possible to append a suffix like k
> for 1 KBytes, m for 1 MBytes...
> 
> So there's a reference of small k and m there, but then later
> references for capitalized KMGTPE, so maybe the reference could be
> more like e.g. LVM where it's described as [bBsSkKmMgGtTpPeE] and just
> omit the sS for sectors since this isn't supported.

Yep, this should be unified.
