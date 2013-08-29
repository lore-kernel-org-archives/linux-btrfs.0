Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab3H2TCa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:02:30 -0400
Date: Thu, 29 Aug 2013 12:02:26 -0700
From: Zach Brown <zab@redhat.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: optimize key searches in btrfs_search_slot
Message-ID: <20130829190226.GQ26818@lenny.home.zabbo.net>
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
 <1377784766-7552-1-git-send-email-fdmanana@gmail.com>
 <20130829180816.GO26818@lenny.home.zabbo.net>
 <CAL3q7H612-zhP1tydL+5M1zdZKtbZYdVmhVKeyEYiH_+wjF7UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H612-zhP1tydL+5M1zdZKtbZYdVmhVKeyEYiH_+wjF7UA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >> +     if (level == 0)
> >> +             offset = offsetof(struct btrfs_leaf, items);
> >> +     else
> >> +             offset = offsetof(struct btrfs_node, ptrs);
> >
> > (+10 fragility points for assuming that the key starts each struct
> > instead of using [0].key)
> 
> Ok. I just copied that from ctree.c:bin_search(). I guess that gives
> another +10 fragility points.
> Thanks for pointing out.

Yeah.  Don't worry, you have quite a way to go before building up
personal fragility points that come anywhere near the wealth of
fragility points that btrfs has in the bank :).

- z
