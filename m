Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:43506 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515AbaJNWLf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 18:11:35 -0400
Message-ID: <543D9DA9.50702@pobox.com>
Date: Tue, 14 Oct 2014 15:03:21 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs random filesystem corruption in kernel 3.17
References: <543450DC.90504@prnet.org>	<1412714780.2374.0@mail.thefacebook.com> <543A61EE.7070200@prnet.org>	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>	<543C35C3.9070002@prnet.org>	<CAGfcS_n5+ToT6kM5+J9TLjdwpriC3uu7hg2HVZXTmTSo-URO9Q@mail.gmail.com>	<pan$e02d1$5d8cd0cc$87f3cfc$b14a0d51@cox.net>	<c2103f1c229cdd887b8743d0946a8a8f@prnet.org> <pan$67a58$c42f6156$af002a14$c1094f5a@cox.net>
In-Reply-To: <pan$67a58$c42f6156$af002a14$c1094f5a@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/14/2014 02:35 PM, Duncan wrote:
> But at some point, presumably after a fix is in place, since the damaged
> snapshots aren't currently always deletable, if the fix only prevents new
> damage from occurring and doesn't provide a way to fix the damaged ones,
> then mkfs would be the only way to do so.  With the damage limited to
> those snapshots and not spreading to normal writable snapshots or the
> working copy, dropping everything to do that mkfs isn't urgent, but it
> (the mkfs) will need to be done at some point to clear the undeletable
> snapshots, again, assuming the fix doesn't provide a way to get rid of
> them (the currently undeletable snapshots).


What happens if "btrfs property set" is used to (attempt to) promote the 
snapshot from read-only to read-write? Can the damaged snapshot then be 
subjected to scrub of btrfsck?

e.g.

btrfs property set /path/to/snapshot ro false
(maintenance here)

