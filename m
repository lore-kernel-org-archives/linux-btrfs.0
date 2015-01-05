Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57657 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752868AbbAEBol (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 20:44:41 -0500
Message-ID: <1420422144.2384.6.camel@localhost.localdomain>
Subject: Re: [PATCH v3] btrfs-progs: Documentation: add T/P/E description
 for resize cmd
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        <takeuchi_satoru@jp.fujitsu.com>
Date: Mon, 5 Jan 2015 09:42:24 +0800
In-Reply-To: <20150102162143.GC6114@twin.jikos.cz>
References: <20141229160712.GK6490@twin.jikos.cz>
	 <1419904337-9945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <CAJCQCtSeguD-oC9ikBc-Mn6_xeu2f-EbfLSFLpSOKgVsEs-T5g@mail.gmail.com>
	 <20150102161204.GB6114@twin.jikos.cz> <20150102162143.GC6114@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2015-01-02 at 17:21 +0100, David Sterba wrote:
> On Fri, Jan 02, 2015 at 05:12:04PM +0100, David Sterba wrote:
> > On Thu, Jan 01, 2015 at 08:27:55PM -0700, Chris Murphy wrote:
> > > Small problem with the rendering of this commit
> > > d4ef1a06f8be623ae94e4d498c306e8dd1605bef, when I use 'man btrfs
> > > filesystem' the above portion looks like this:
> > > 
> > >  'K', 'M', 'G', 'T', 'P', or 'E\',
> > > 
> > > I'm not sure why there's a trailing slash after the E.
> > 
> > Me neither, but it looks like a bug in the asciidoc processing.
> 
> Seems that only the first ' has to be quoted, and consumes the next
> unquoted ' as a pair, so with the last \' the next one is missing and
> is printed verbatim:
> 
> Fixed by:
> 
> -units designators: \'K\', \'M\', \'G\', \'T\', \'P\', or \'E\', which represent
> +units designators: \'K', \'M', \'G', \'T', \'P', or \'E', which represent
> 

Oh, sorry, I missed this problem, thanks for fixing it.

-Gui

