Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36674 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2KHRbN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 12:31:13 -0500
Message-ID: <509BEC60.9080200@giantdisaster.de>
Date: Thu, 08 Nov 2012 18:31:12 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
References: <cover.1352214751.git.sbehrens@giantdisaster.de> <5099C40C.6030003@jp.fujitsu.com> <509A5E4F.7090408@giantdisaster.de> <CAJHuE_AD+EkAwKdMbLQwkRNzc+6qc9=xNziQfREV--GLUcz7Sw@mail.gmail.com>
In-Reply-To: <CAJHuE_AD+EkAwKdMbLQwkRNzc+6qc9=xNziQfREV--GLUcz7Sw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 8 Nov 2012 13:50:19 +0100, Goffredo Baroncelli wrote:
> great work. However I have a suggestion: what about putting all the
> command under 'device' sub commands: something like:
> 
> - btrfs device replace <old> <new> </path>
> 
> - btrfs device status </path>
> 
> Where "btrfs device status" would show only the status of the
> "replacing" operation; but in the future it could show also the status
> of the "delete" command (which it is the only other "device
> sub-command" which needs time to complete).
> 
> Of course I am not asking to complete the "btrfs device status" part
> for the "btrfs device delete" command. This could be implemented in a
> second time.
> 
> I think that so "replace" would be the natral extension to the "add"
> and "delete" subcommands.

"btrfs device replace <old> <new> <path>"
was also my first idea. It used to be like this initially.

"btrfs device replace cancel <path>"
was the point when I gave up putting it below the "device" commands. IMO
that's just too long, too much to type.

Now it has the same look and feel as the "scrub" commands ("scrub
start", "scrub status" and "scrub cancel").

