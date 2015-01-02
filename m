Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbbABQVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Jan 2015 11:21:45 -0500
Date: Fri, 2 Jan 2015 17:21:43 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Chris Murphy <lists@colorremedies.com>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: [PATCH v3] btrfs-progs: Documentation: add T/P/E description for
 resize cmd
Message-ID: <20150102162143.GC6114@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141229160712.GK6490@twin.jikos.cz>
 <1419904337-9945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <CAJCQCtSeguD-oC9ikBc-Mn6_xeu2f-EbfLSFLpSOKgVsEs-T5g@mail.gmail.com>
 <20150102161204.GB6114@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150102161204.GB6114@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 02, 2015 at 05:12:04PM +0100, David Sterba wrote:
> On Thu, Jan 01, 2015 at 08:27:55PM -0700, Chris Murphy wrote:
> > Small problem with the rendering of this commit
> > d4ef1a06f8be623ae94e4d498c306e8dd1605bef, when I use 'man btrfs
> > filesystem' the above portion looks like this:
> > 
> >  'K', 'M', 'G', 'T', 'P', or 'E\',
> > 
> > I'm not sure why there's a trailing slash after the E.
> 
> Me neither, but it looks like a bug in the asciidoc processing.

Seems that only the first ' has to be quoted, and consumes the next
unquoted ' as a pair, so with the last \' the next one is missing and
is printed verbatim:

Fixed by:

-units designators: \'K\', \'M\', \'G\', \'T\', \'P\', or \'E\', which represent
+units designators: \'K', \'M', \'G', \'T', \'P', or \'E', which represent

