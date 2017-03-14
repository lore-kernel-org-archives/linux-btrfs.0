Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43972 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752790AbdCNNsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 09:48:38 -0400
Date: Tue, 14 Mar 2017 14:47:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/5] raid56: variant bug fixes
Message-ID: <20170314134759.GB14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170203082023.3577-1-quwenruo@cn.fujitsu.com>
 <b6ba2bec-ea6c-ca7f-5806-ba6c6dfc71f7@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6ba2bec-ea6c-ca7f-5806-ba6c6dfc71f7@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 11:48:37AM +0800, Qu Wenruo wrote:
> So raid56 bug fixes are the same case as qgroup fixes now?

Not now, it's been like that forever. Or should have been, we're not
perfect, but should strive not to skip reviews just because we want to
let new code in.

> No reviewer so no merge?
> 
> I understand we need enough reviewer, however there is never enough 
> reviewer for *minor* functions, like qgroup or raid56.

I would not call them minor. Qgroups are hooked to the core of the
operations, raid56 is a compartment, but can become complex regarding
the error modes and safety constraints.

> Such situation will just make such functions starve, bugs makes fewer 
> tester and users, fewer users leads to even fewer developers, causing a 
> minus spiral.

Unreviewed code is more buggy, leads to the same. You've been around for
a long time, I'm sure you'll remember times when an underreviewed
patchset caused headaches for several major releases. All developers
have record of a major problem in their code, that's why we must do the
reviews.
