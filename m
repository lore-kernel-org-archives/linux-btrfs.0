Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab1GNQzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2011 12:55:32 -0400
Date: Thu, 14 Jul 2011 17:55:16 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
        Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
Message-ID: <20110714165516.GA15253@agk-dp.fab.redhat.com>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110714163836.35a729c1@notabene.brown>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 14, 2011 at 04:38:36PM +1000, Neil Brown wrote:
> It might make sense for a device to be able to report what the maximum
> 'N' supported is... that might make stacked raid easier to manage...
 
I'll just say that any solution ought to be stackable.
This means understanding both that the number of data access routes may
vary as you move through the stack, and that this number may depend on
the offset within the device.

Alasdair

