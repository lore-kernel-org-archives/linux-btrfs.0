Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:40974 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab2GDXbH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 19:31:07 -0400
Date: Thu, 5 Jul 2012 01:31:02 +0200
From: David Sterba <dave@jikos.cz>
To: Alexander Block <ablock84@googlemail.com>
Cc: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 5/7] Btrfs: add btrfs_compare_trees function
Message-ID: <20120704233102.GP5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
 <1341409108-13567-6-git-send-email-ablock84@googlemail.com>
 <CAHf9xvZpRpB8FrgqfPG-s5N4UKUwGAzSsRVeWbQ6GLfwKQOHcA@mail.gmail.com>
 <CAB9VWqCLC-2Kj-N5U-ZRrVjgrrTpRJze2fUBiNzaZQxyFCdvfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB9VWqCLC-2Kj-N5U-ZRrVjgrrTpRJze2fUBiNzaZQxyFCdvfg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2012 at 10:18:34PM +0200, Alexander Block wrote:
> > It might be worth to note in the comment, that tmp_buff should be
> > large enough to hold the item from the left tree. Can it happen that
> > the right tree has a different leafsize?
> >
> This function is only to be used for for the tree compare function and
> there we allocate a buffer of root->leafsize, so definitely all items
> should fit. As far as I know, Chris (please correct me if I'm wrong)
> once guaranteed that ALL trees in a FS will have the same leaf size
> and this will ever be the case.

Not only leaves are of the same size in all trees, but also nodes, since
the metadata bigblocks patches.

david
