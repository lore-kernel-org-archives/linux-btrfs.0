Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:44183 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696Ab2IDV5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Sep 2012 17:57:37 -0400
Date: Tue, 4 Sep 2012 17:57:13 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] opensvc btrfs send/receive driver
Message-ID: <20120904215713.GA8857@shiny.int.fusionio.com>
References: <1346779594.24415.17.camel@lapoo.opensvc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1346779594.24415.17.camel@lapoo.opensvc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 04, 2012 at 11:26:34AM -0600, Christophe Varoqui wrote:
> Here are the stacks encountered during the opensvc btrfs send/receive
> development.
> 
> The system is a debian squeeze amd64 in a kvm over debian squeeze amd64.
> The disks handed to btrfs are logical volumes passed to the kvm as vdb
> and vdc. The vm kernel is 3.6rc3 and btrfs-progs are at git commit
> 043a63924c9831ac52ce38f0365b9bfd628fb6a3 (Thu, 9 Aug 2012).

Ok, could you please try to reproduce with my send-receive branch on the
kernel side?

-chris
