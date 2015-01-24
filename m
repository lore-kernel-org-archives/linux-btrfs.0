Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45666 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbbAXN2s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Jan 2015 08:28:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YF0lY-0001A1-Bk
	for linux-btrfs@vger.kernel.org; Sat, 24 Jan 2015 14:28:44 +0100
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Jan 2015 14:28:44 +0100
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Jan 2015 14:28:44 +0100
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: "btrfs send" and interrupts
Date: Sat, 24 Jan 2015 15:28:32 +0200
Message-ID: <m49y4osnw8v.fsf@coffee.modeemi.fi>
References: <20150123095846.GC26830@smurf.noris.de>
	<54C25BAB.50102@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide <brendan@swiftspirit.co.za> writes:
> Interesting case. I'm not sure of the merits/workaround needed to do
> this. It appears even using cat into netcat (nc) causes netcat to quit
> if you background the operation.

Well, that netcat has a bug doesn't mean btrfs-progs should have one as
well :) (though I didn't manage to reproduce this with my netcat using
tar c ~ | netcat host discard). Neither ssh nor socat mind being
suspended and foregrounded.

I imagine the fix is pretty trivial as well. Possibly a read - or a
write - is short when it is assumed to be full, or possibly an EINTR is
mishandled. (Though it could be more complicated if the operation is
inside the kernel..)

While the reasons for using screen you list are good to take into
account, the advantage of that is that it protects against an error; but
job control no error but the standard way for controlling jobs within a
single terminal, and for example in this kind of case actually
suspending the transfer for a while can be a desirable operation, ie. to
reduce system/network/io load for achieving another concurrent operation
faster.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

