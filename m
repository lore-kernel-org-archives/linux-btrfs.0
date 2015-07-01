Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbbGAN03 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jul 2015 09:26:29 -0400
Date: Wed, 1 Jul 2015 15:26:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Trollkarlen Marklund <robbelibobban@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] check: check so offset is not bigger then the leaf
Message-ID: <20150701132627.GK726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434585553-8697-1-git-send-email-robbelibobban@gmail.com>
 <20150618164443.GH6761@twin.jikos.cz>
 <3FC07E8E-F789-4C2A-9099-F649EFADCD1F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3FC07E8E-F789-4C2A-9099-F649EFADCD1F@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 29, 2015 at 02:16:28PM +0300, Trollkarlen Marklund wrote:
> > Do you have a crafted filesystem image that can reproduce that or was
> > that found by code inspection?
> 
> I have a failed filesystem caused by a failing disk that I tried to fix/recover.
> Then i stumbled on this, and later on on some more places other then this.
> Ill submit that also and in a nicer way when my filesystem is rescued. 

FYI, I've committed a patch based on the discussion in the thread.
