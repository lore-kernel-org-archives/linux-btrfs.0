From: Dave Jones <davej@redhat.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Mon, 2 Apr 2012 21:47:22 -0400
Message-ID: <20120403014722.GA618@redhat.com>
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
 <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, jeffm@suse.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120402235021.GA20070@shiny.msi.event>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2012 at 07:50:50PM -0400, Chris Mason wrote:

 > > I'll start a bisect later to see if I can narrow it down at least.
 > 
 > Ok, a directed bisect of the major suspects.  Josef changed the extent
 > buffer eio code in this commit (jump to the commit before it):

I had already started before I read your mail, so I just did the whole bisect..
It ended on this...

49b25e0540904be0bf558b84475c69d72e4de66e is the first bad commit
commit 49b25e0540904be0bf558b84475c69d72e4de66e
Author: Jeff Mahoney <jeffm@suse.com>
Date:   Thu Mar 1 17:24:58 2012 +0100

    btrfs: enhance transaction abort infrastructure
    
    Signed-off-by: Jeff Mahoney <jeffm@suse.com>

:040000 040000 f4b5cdd26617e049962e08b94643dd2134014b00 1455feb78b615f13d3c60acf5f0fad44ad133ded M	fs



bisect log:
git bisect start 'fs/'
# bad: [bc3f116fec194f1d7329b160c266fe16b9266a1e] Btrfs: update the checks for mixed block groups with big metadata blocks
git bisect bad bc3f116fec194f1d7329b160c266fe16b9266a1e
# good: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
git bisect good c16fa4f2ad19908a47c63d8fa436a1178438c7e7
# bad: [65139ed99234d8505948cdb7a835452eb5c191f9] btrfs: disallow unequal data/metadata blocksize for mixed block groups
git bisect bad 65139ed99234d8505948cdb7a835452eb5c191f9
# good: [3fbe5c02ae5a59053d779392b9a12aa8f6d6198e] btrfs: split extent_state ops
git bisect good 3fbe5c02ae5a59053d779392b9a12aa8f6d6198e
# good: [305a26af5b2561a66859ef05ed7eb73d3c9f0913] btrfs: Go readonly on tree errors in balance_level
git bisect good 305a26af5b2561a66859ef05ed7eb73d3c9f0913
# good: [4da35113426d16673aa1fb0613c14ca2e419e7fd] btrfs: add varargs to btrfs_error
git bisect good 4da35113426d16673aa1fb0613c14ca2e419e7fd
# bad: [79787eaab46121d4713ed03c8fc63b9ec3eaec76] btrfs: replace many BUG_ONs with proper error handling
git bisect bad 79787eaab46121d4713ed03c8fc63b9ec3eaec76
# bad: [49b25e0540904be0bf558b84475c69d72e4de66e] btrfs: enhance transaction abort infrastructure
git bisect bad 49b25e0540904be0bf558b84475c69d72e4de66e
