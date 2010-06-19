From: Andi Kleen <andi@firstfloor.org>
Subject: Re: idea about internal fragmentation in Btrfs
Date: Sat, 19 Jun 2010 10:51:22 +0200
Message-ID: <87k4pvo16d.fsf@basil.nowhere.org>
References: <AANLkTilWguh4IrDHVgtTxjoiAeSy23SK_M1dWapgvSDt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Zhihui Zhang <zzhsuny@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilWguh4IrDHVgtTxjoiAeSy23SK_M1dWapgvSDt@mail.gmail.com>
	(Zhihui Zhang's message of "Fri, 18 Jun 2010 14:12:22 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Zhihui Zhang <zzhsuny@gmail.com> writes:

> I wish Btrfs well, so I would venture an idea for this specific case
> mentioned by Edward Shishkin today.
>
> Everyone knows that B-tree has internal and leaf nodes.  Can we make
> the root as the leaf?  In other words, if you
> create a 2K file, the B-tree will have only one node, which is both
> the root and the leaf. Of course, you need some flag to
> say this is a "degenerated" form of B-tree. Please cc me if you want
> my response.

You need to copy linux-btrfs to reach btrfs developers.
Ccs added

The problem with your idea is that on btrfs there's only 
a single tree for the whole fs (or whole snapshot rather)
So it would only work for a single file because there's
only a single root.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
