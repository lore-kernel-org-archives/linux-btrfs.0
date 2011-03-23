From: Andi Kleen <andi@firstfloor.org>
Subject: Re: stratified B-trees
Date: Wed, 23 Mar 2011 11:01:48 -0700
Message-ID: <m2wrjp7m2b.fsf@firstfloor.org>
References: <201103231208.52592.tierpluspluslists@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tierpluspluslists@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201103231208.52592.tierpluspluslists@gmail.com> (Karn Kallio's
	message of "Wed, 23 Mar 2011 12:08:52 -0430")
List-ID: <linux-btrfs.vger.kernel.org>

Karn Kallio <tierpluspluslists@gmail.com> writes:

> Are these stratified B-trees something which the btrfs project could use?

The current b*tree is pretty much hardcoded in the disk format, so it 
would be hard to change in a compatible way.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
