Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab3JOV6W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 17:58:22 -0400
Date: Tue, 15 Oct 2013 23:58:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix incorrect inode acl reset
Message-ID: <20131015215819.GQ5787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381859040-11211-1-git-send-email-fdmanana@gmail.com>
 <20131015180017.GC14323@localhost.localdomain>
 <CAL3q7H4GfCHX0hOuR6Som4N8KZqQ0p4Z0M9PTCw_8guSV=2r+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4GfCHX0hOuR6Som4N8KZqQ0p4Z0M9PTCw_8guSV=2r+g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 07:02:47PM +0100, Filipe David Manana wrote:
> > Can you put this into an xfstest please?  Thanks,
> 
> A new one or just add it to an existing one (and which)?

There's xfstests/shared/051 that tests ACLs, but is run only against xfs
and udf. I haven't verified it wrt btrfs, but maybe this test catches
the bug. If not, please add a new test into the 'generic' category.

thanks,
david
