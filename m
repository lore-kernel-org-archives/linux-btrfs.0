Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaGBLPg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 07:15:36 -0400
Date: Wed, 2 Jul 2014 13:15:34 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add supported attr flags to btrfs(5)
Message-ID: <20140702111534.GA1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53AC84C9.2080106@redhat.com>
 <20140627134257.GE1553@twin.jikos.cz>
 <53AD860A.8090804@redhat.com>
 <20140627153017.GF1553@suse.cz>
 <53AD8F96.4060401@redhat.com>
 <20140627161025.GG1553@suse.cz>
 <53AD9DF2.9030200@redhat.com>
 <20140701174346.GP1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140701174346.GP1553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 01, 2014 at 07:43:46PM +0200, David Sterba wrote:
> > (only nitpick: is 'X' ever reported by lsattr on btrfs?  If so,
> > it could/should still be included)
> 
> I'll take a look and will keep 'X' if it's visible somewher.

For the record, with sufficiently new e2fsprogs 'X' appears if the file
has the NOCMPRESS bit set.
