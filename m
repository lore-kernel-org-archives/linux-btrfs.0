Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbbHGOTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Aug 2015 10:19:31 -0400
Date: Fri, 7 Aug 2015 16:19:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Robert Munteanu <robert.munteanu@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] Fix for infinite loop on non-empty inode but with no
 file extent
Message-ID: <20150807141908.GB10756@suse.cz>
Reply-To: dsterba@suse.cz
References: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150805164057.GC31669@twin.jikos.cz>
 <CAC8ULPad3LTcegecjV6s-HxK8Yn-k72Eh6=AN5VayeraUO4GzQ@mail.gmail.com>
 <20150807140043.GA10756@suse.cz>
 <CAC8ULPbMGFigOhP_NwwD4-qYWEBOwKwgxyzWA5V_su5UtO1-FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC8ULPbMGFigOhP_NwwD4-qYWEBOwKwgxyzWA5V_su5UtO1-FQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 07, 2015 at 05:17:34PM +0300, Robert Munteanu wrote:
> Thanks for the update. Reading it looks to me like the patches should be at
> 
>   http://repo.or.cz/w/btrfs-progs-unstable/devel.git/shortlog/refs/heads/devel
> 
> but they don't seem to be . Am I long in the wrong place again :-) ?

Doh, I forgot to push the branch, sorry.
