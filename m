Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59133 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab2IXMCk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 08:02:40 -0400
Date: Mon, 24 Sep 2012 14:02:32 +0200
From: David Sterba <dave@jikos.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: btrfs subvolume delete could delete
 subvolumes
Message-ID: <20120924120232.GB14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com>
 <20120921152051.GU17430@twin.jikos.cz>
 <505FCC96.8030703@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505FCC96.8030703@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 10:59:34AM +0800, Anand Jain wrote:
> > Yes, this is useful, thanks. I'm thinking if it's ok to stop on
> > first error, ie. when the subvolume does not exist or is a directory.
> 
>  I am fine with either ways. I shall just keep it as it is as of now.

Yes, I'm ok with that. The usecase I had in mind was something like

  btrfs subvol del *

but I should know the dir I'm in and what I'm doing there, errors are
to be expected.


david
