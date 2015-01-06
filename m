Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbbAFMWE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 07:22:04 -0500
Date: Tue, 6 Jan 2015 13:22:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reada: Remove unused function
Message-ID: <20150106122201.GH6114@suse.cz>
Reply-To: dsterba@suse.cz
References: <1420333197-6245-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20150105133356.GF6114@twin.jikos.cz>
 <alpine.LRH.2.00.1501061141250.20601@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LRH.2.00.1501061141250.20601@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 06, 2015 at 11:42:07AM +0100, Jiri Kosina wrote:
> On Mon, 5 Jan 2015, David Sterba wrote:
> 
> > > Remove the function btrfs_reada_detach() that is not used anywhere.
> > > 
> > > This was partially found by using a static code analysis program called cppcheck.
> > > 
> > > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > 
> > No please, this function is part of public readahead API and similar
> > patch has been NACKed several times.
> 
> BTW how is this any kind of API for anybody, given it's not exported to 
> modules?

Scratch 'public' from the sentence, that was misleading. The API is internal to
btrfs.  The readahead can work in synchronous and asynchronous modes, this
function is API to the async mode.

Documented at reada.c:

 34 /*
 35  * This is the implementation for the generic read ahead framework.
 36  *
 37  * To trigger a readahead, btrfs_reada_add must be called. It will start
 38  * a read ahead for the given range [start, end) on tree root. The returned
 39  * handle can either be used to wait on the readahead to finish
 40  * (btrfs_reada_wait), or to send it to the background (btrfs_reada_detach).
 41  *
...

I've experimented with it for readdir speedups, but I haven't finished that due
to other problems.
