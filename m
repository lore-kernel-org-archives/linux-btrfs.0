Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38336 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbcDDUKh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 16:10:37 -0400
Date: Mon, 4 Apr 2016 23:10:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] delete obsolete function btrfs_print_tree()
Message-ID: <20160404201017.GA5502@mwanda>
References: <56F550DD.1030200@googlemail.com>
 <20160404135641.GB3412@twin.jikos.cz>
 <57028E42.1090901@googlemail.com>
 <CAL3q7H5XDU2sNEVmYYsc7L72zCbN7Dpdx-nsSETwdJQd529z0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5XDU2sNEVmYYsc7L72zCbN7Dpdx-nsSETwdJQd529z0A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 04, 2016 at 05:02:38PM +0100, Filipe Manana wrote:
> It's not serious if it doesn't have all the proper error handling
> and etc, it's just something for debugging purposes.

I'm slowly trying to remove static checker warnings so that we can
detect real bugs.  People sometimes leave little messages for me in
their code because they know I will review the new warning:

	foo = kmalloc();
	/* error handling deliberately left out */

It make me quite annoyed because it's like "Oh.  No if we added error
handling that would take 40 extra bytes of memory!  Such a waste!"  But
we could use instead use___GFP_NOFAIL instead.  Or BUG_ON(!foo)".  I
have gotten distracted.  What was the question again?

regards,
dan carpenter

