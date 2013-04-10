Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab3DJPmf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 11:42:35 -0400
Date: Wed, 10 Apr 2013 17:42:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, martin.krizek@gmail.com
Subject: Re: [PATCH 1/2] Btrfs: online data deduplication
Message-ID: <20130410154233.GP18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
 <1365340369-23537-2-git-send-email-bo.li.liu@oracle.com>
 <20130408134726.GD18193@twin.jikos.cz>
 <20130408140853.GB27988@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130408140853.GB27988@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 08, 2013 at 10:08:54PM +0800, Liu Bo wrote:
> > Is it safe to use just 64 bits? I'd like to see better reasoning why
> > this is ok. The limitation of btrfs_key to store only 1-2 64bit items is
> > clear and must be handled, but it's IMO a critical design point.
> 
> Actually I use the whole 256bit hash value(stored in its item) to avoid hash
> collision, not just the stop 64bit.

Ok. It's good to point such things in the changelog/design docs, such
things may not be immediatelly clear from the code.

> > Last but not least, there was another dedup proposal (author CCed)
> > 
> > http://thread.gmane.org/gmane.comp.file-systems.btrfs/21722
> 
> I waited for 2 months and wanted to see the actual code from the proposal, but I
> failed, so I decided to do it myself.

Quoting from the mail:

"My goal is to study Btrfs design, the offline deduplication patch [1]
and to come up with a design for the online dedup, this semester. I will
be implementing the feature next semester (spring, that is)."

So the implementation starts about now ...

> Anyway I'd like to see this feature in btrfs no matter who write it down.

We'll end up with 2 implementations that are likely doing different
tradeoffs and once one is merged the other one can be thrown away
wasting time and efforts.

Not my problem, but I don't uderstand why there's another implementation
when the dedup project has been informally claimed (via mailinglist).


david
