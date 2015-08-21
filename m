Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:43622 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbbHUPjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 11:39:53 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empry directory pretending it is not empty
Date: Fri, 21 Aug 2015 17:39:49 +0200
Message-ID: <1563126.2Gc1A7GJcV@zafu>
In-Reply-To: <pan$3546e$3dbd1a66$4b200cff$9537e206@cox.net>
References: <2017000.AEG9PyVY17@zafu> <pan$3546e$3dbd1a66$4b200cff$9537e206@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

Thank you all for your replies and suggestions, please see below.

Le vendredi 21 août 2015 11:23:19 Duncan a écrit :
> AFAIK, the bug is now fixed, but for those affected, the bad-refcounts 
> remain.  I believe btrfs check should detect the problem and with
> --repair should fix it, but of course caution is urged in using --repair 
> as there's still a chance it'll do damage if there's other problems it 
> doesn't understand and thus tries to fix in the wrong way.
> 
> So I'd suggest running btrfs check, without --repair, first, and see what 
> it says.  If the only reported problems have to do with inode refcounts, 
> then (assuming your backups are current, just in case, admin's rule of 
> backups, if you don't have them, you don't care about losing the data) 
> I'd then go ahead and run it with --repair.
> 
> Of course to do that you'll have to have the filesystem unmounted, and 
> have access to a reasonably new btrfs command on the initr* or from your 
> emergency boot, if it's the root filesystem.  Could be fun... but it 
> should correct the issue.

I hadn't considered using btrfsck, as I has understood that BTRFS was 
typically supposed to be self-repairing and that btrfsck was a last-resort 
tool to be used only when the filesystem would be unmountable, and furthermore 
that using it *might* be kind of trying to do precision surgery using a 
chainsaw ;-)

But I might give it a shot, taking in account that yes, this is a subvolume of 
my root filesystem (which I would obviously prefer not to break even though I 
have backups...) and that I should seek a live distro image having a recent 
kernel and BTRFS tools...

In the past, the output of btrfsck was completely meaningless to me, so I'm 
not sure if I could figure out anything from it (and understand if I'd better 
try the repair option or not...) by running it a first time.

Even though I have backups, I don't have too much time and desire for breaking 
and restoring my system, and I'd rather keep this "dead" directory forever 
rather than taking any risk of frying my root FS...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

