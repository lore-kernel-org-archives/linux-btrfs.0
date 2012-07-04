Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36517 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2GDPvM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 11:51:12 -0400
Date: Wed, 4 Jul 2012 17:51:03 +0200
From: David Sterba <dave@jikos.cz>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_print_tree?
Message-ID: <20120704155103.GO5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAEH94Lht_TcBFa1qvO1-pz12GsdfH05xnYMC-smKLOFPP2HydA@mail.gmail.com>
 <CAMU1PDgEokfvoCREVwB9O4Mm0Po=9UdFau3W2D0nZhhf2oWNsw@mail.gmail.com>
 <CAEH94LhNWsye0HsDjroeRQ76vLkmKSUwYwzGKjfbJCeO-wLEuw@mail.gmail.com>
 <4FF02397.3040002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF02397.3040002@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 01, 2012 at 06:16:55PM +0800, Jeff Liu wrote:
> On 07/01/2012 05:49 PM, Zhi Yong Wu wrote:
> 
> > On Sun, Jul 1, 2012 at 5:41 PM, Mike Fleetwood
> > No, i also did as this, but didn't find out who will invoke this
> > function. From above output, we only saw that it invokes itself one
> > time.
> 
> Looks this is a helper routine exported to btrfs-progs previously, it is
> used by debug-tree, quick-test, etc...
> 
> But this function has been implemented at btrfs-progs now, maybe it
> could be safely removed from kernel, not sure. :)

Please do not remove that function, it could be helpful for debugging
prints.

david
