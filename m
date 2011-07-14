From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 17:55:16 +0100
Message-ID: <20110714165516.GA15253__7911.34883552349$1310662560$gmane$org@agk-dp.fab.redhat.com>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@orac
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110714163836.35a729c1@notabene.brown>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 14, 2011 at 04:38:36PM +1000, Neil Brown wrote:
> It might make sense for a device to be able to report what the maximum
> 'N' supported is... that might make stacked raid easier to manage...
 
I'll just say that any solution ought to be stackable.
This means understanding both that the number of data access routes may
vary as you move through the stack, and that this number may depend on
the offset within the device.

Alasdair

