Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab3ICN2K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 09:28:10 -0400
Date: Tue, 3 Sep 2013 15:28:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Simon Farnsworth <simon@farnz.org.uk>
Cc: Mark Fasheh <mfasheh@suse.de>, Gabriel de Perthuis <g2p.code@gmail.com>,
        Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PROGS PATCH] Import btrfs-extent-same
Message-ID: <20130903132807.GA18147@suse.cz>
Reply-To: dsterba@suse.cz
References: <51CB6D5B.70302@gmail.com>
 <20130813193515.GG31381@wotan.suse.de>
 <20130902164358.GE23113@twin.jikos.cz>
 <2014964.FiAiDKtOtq@f17simon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2014964.FiAiDKtOtq@f17simon>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 02, 2013 at 05:53:42PM +0100, Simon Farnsworth wrote:
> On Monday 2 September 2013 18:43:58 David Sterba wrote:
> > Yes that's what I meant and that's what dupremove in your git tree does,
> > right?
> > 
> > Using the EXTENT_SAME ioctl without any checks is dangerous, and that's
> > what btrfs-extent-same.c does, so it's suitable for testing but not
> > about to be given to users as-is.
> > 
> Why is using EXTENT_SAME without any checks dangerous?
>
> If userspace has to do checks to guarantee safety, what stops an attacker
> deliberately triggering a TOCTTOU race against a checked user of EXTENT_SAME?
> I would expect that unchecked use of EXTENT_SAME simply causes the kernel to
> return BTRFS_SAME_DATA_DIFFERS most of the time, thus slowing you down.

I was mistaken, the ioctl does checks before merging the extents. Sorry
for confusion.

david
