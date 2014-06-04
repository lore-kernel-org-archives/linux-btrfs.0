Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaFDQoj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 12:44:39 -0400
Date: Wed, 4 Jun 2014 18:44:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Hesse <mail@eworm.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: fix compiler warning
Message-ID: <20140604164437.GA1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401794959-25907-1-git-send-email-mail@eworm.de>
 <538EC135.6060105@cn.fujitsu.com>
 <20140604091926.37ad5ef2@leda.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140604091926.37ad5ef2@leda.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 04, 2014 at 09:19:26AM +0200, Christian Hesse wrote:
> > It seems to be related to default gcc flags from distribution?
> 
> Probably. I did compile with optimization, so adding -O2 may do the trick:
> 
> make CFLAGS="${CFLAGS} -O2" all

The warning appears with -O2, so the question is if gcc is not able to
reason about the values (ie. a false positive) or if there's a bug that
I don't see.
