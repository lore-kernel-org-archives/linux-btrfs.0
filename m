Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752052AbdFLMrk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:47:40 -0400
Date: Mon, 12 Jun 2017 14:46:29 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Filip Bystricky <filipbystricky@google.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs native encryption
Message-ID: <20170612124629.GG25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
 <20170612124038.GF25451@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170612124038.GF25451@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 12, 2017 at 02:40:38PM +0200, David Sterba wrote:
> On Fri, Jun 09, 2017 at 08:50:12AM -0700, Filip Bystricky wrote:
> > Dear btrfs maintainers,
> > Google is evaluating btrfs for its potential use in android, but
> > currently the lack of native file-based encryption unfortunately makes
> > it a nonstarter.
> 
> The file-based encryption is covered by the fscrypt API, that's
> implemented in ext4/f2fs, so implementing that in btrfs could allow you
> to start evaluating btrfs.

For reference I'll add it here,
https://github.com/asj/linux-btrfs-fscryptv1 seems to implement it, I've
only scrolled through it so I don't know how usable is it in this state.
