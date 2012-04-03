From: David Sterba <dsterba@suse.cz>
Subject: Re: btrfs io errors on 3.4rc1
Date: Tue, 3 Apr 2012 18:33:43 +0200
Message-ID: <20120403163343.GD14083@ds.suse.cz>
References: <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
 <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
 <20120403014722.GA618@redhat.com>
 <20120403142607.GA14083@ds.suse.cz>
 <20120403162023.GA7227@redhat.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>, David Sterba <dsterba@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, jeffm@suse.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120403162023.GA7227@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2012 at 12:20:23PM -0400, Dave Jones wrote:
> I see a lot of these ..
> 
> btrfs: __btrfs_end_transaction -EIO abored=1802201963 (no super error)

1802201963 == 0x6b6b6b6b

#define POISON_FREE     0x6b    /* for use-after-free poisoning */

hmm
