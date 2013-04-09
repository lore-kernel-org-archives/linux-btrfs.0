Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab3DILMK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 07:12:10 -0400
Date: Tue, 9 Apr 2013 13:12:08 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make btrfs dev scan multi path aware
Message-ID: <20130409111208.GF18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363867004-22912-1-git-send-email-anand.jain@oracle.com>
 <20130408152238.GE18193@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130408152238.GE18193@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 08, 2013 at 05:22:38PM +0200, David Sterba wrote:
> > +	fd = open("/dev/btrfs-control", O_RDWR);
> > +	e = errno;
> > +	if (fd < 0) {
> > +		FILE *mfd = popen("lsmod | grep btrfs", "r");
> Please transform this into C.

Actually, what if btrfs is not built as a module? There should be another
way to detect that btrfs is compiled in, like opening the control device
and reading something back.

david
