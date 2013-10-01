Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3JARDq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 13:03:46 -0400
Date: Tue, 1 Oct 2013 19:03:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Sterba <dsterba@suse.cz>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: Handful of btrfs fixes for 3.11.x stable
Message-ID: <20131001170344.GA8551@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
 <20130920165301.GA11262@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130920165301.GA11262@kroah.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Greg,

On Fri, Sep 20, 2013 at 09:53:02AM -0700, Greg KH wrote:
> Thanks for this, I'll queue them up soon.

3.11.3 has been just released and the btrfs fixes are not there nor in
the stable-queue git repo. There's a fix for a crash that affects
a number of users. Please queue the patches or let me know what's needed
to get them to stable tree.

thanks,
david
