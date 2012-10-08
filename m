Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60778 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab2JHQmf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 12:42:35 -0400
Date: Mon, 8 Oct 2012 18:42:27 +0200
From: David Sterba <dave@jikos.cz>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121008164227.GH4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121008151513.GE24071@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 04:15:14PM +0100, Richard W.M. Jones wrote:
> Unfortunately I'm struggling to reproduce this outside of our build
> system (Koji).  I will keep you informed if I do manage to reproduce
> it locally.  Adding fsync /dev/sda1 was also my first instinct :-)

Have you updated the VM/guest related packages recently? This may be a
bug in the VM drivers.

david
