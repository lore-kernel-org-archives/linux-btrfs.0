Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbbIKOql (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 10:46:41 -0400
Date: Fri, 11 Sep 2015 16:45:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix cross stripe boundary check
Message-ID: <20150911144553.GN8891@suse.cz>
Reply-To: dsterba@suse.cz
References: <1441897376-5572-1-git-send-email-dsterba@suse.com>
 <CAHji1518hEv2_H08ucBYNmvGA2qA=fLs4J+FAFSXEHWv5G8KUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAHji1518hEv2_H08ucBYNmvGA2qA=fLs4J+FAFSXEHWv5G8KUA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 11, 2015 at 03:16:02PM +0200, Holger Hoffstätte wrote:
> Am I correct that this also causes false positives with btrfs check? I just
> ran a sanity check on an fs that had no problems whatsoever and was
> definitely not converted (so 16k nodesize) and got thousands of
> cross-stripe complaints; repair didn't help. Applying the patch seems to
> have fixed those; it completes without problems now.

Yes you are. If the node blocks end at the stripe boundary, they're
incorrectly marked as stripe crossing. The 64k nodesize case was quick
to detect that because this holds for all nodes. Thanks for your
report, this means the bug is not that rare. I'll do a release within a
few days including this patch.
