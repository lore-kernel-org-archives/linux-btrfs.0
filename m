From: Dave Jones <davej@redhat.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Tue, 3 Apr 2012 12:20:23 -0400
Message-ID: <20120403162023.GA7227@redhat.com>
References: <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
 <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
 <20120403014722.GA618@redhat.com>
 <20120403142607.GA14083@ds.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, jeffm@suse.com
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120403142607.GA14083@ds.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2012 at 04:26:07PM +0200, David Sterba wrote:
 > On Mon, Apr 02, 2012 at 09:47:22PM -0400, Dave Jones wrote:
 > > 49b25e0540904be0bf558b84475c69d72e4de66e is the first bad commit
 > >     btrfs: enhance transaction abort infrastructure
 > 
 > Attached patch adds several debugging printks to help to track down
 > where the EIOs come from. As there are no messages in syslog, it happens
 > on a regular path and not after a transaction abort.
 > 
 > I was not able to trigger the problem with either fsx or full xfstests
 > suite (3.4-rc).
 > 


I see a lot of these ..

btrfs: __btrfs_end_transaction -EIO abored=1802201963 (no super error)

	Dave
