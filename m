Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:42744 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbcIPIuQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 04:50:16 -0400
Date: Fri, 16 Sep 2016 10:49:58 +0200
From: David Sterba <dave@jikos.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160916084958.GA933@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 13, 2016 at 09:39:46PM +0800, Anand Jain wrote:
> This patchset adds btrfs encryption support.
> 
> The main objective of this series is to have bugs fixed and stability.
> I have verified with fstests to confirm that there is no regression.
> 
> A design write-up is coming next,

You're approaching it from the wrong side. The detailed specification
must come first. Don't bother to send the code again.

> however here below is the quick example
> on the cli usage. Please try out, let me know if I have missed something.
> 
> Also would like to mention that a review from the security experts is due,
> which is important and I believe those review comments can be accommodated
> without major changes from here.

I disagree. Others commented on the crypto stuff, I see enough points to
address that would lead to major changes.

> Also yes, thanks for the emails, I hear, per file encryption and inline
> with vfs layer is also important, which is wip among other things in the
> list.

Implementing the recent vfs encryption in btrfs is ok, it's just feature
parity using an existing API.

And a note from me with maintainer's hat on, there are enough pending
patches and patchsets that need review, and bugs to fix, I'm not going
to spend time on something that we don't need at the moment if there are
alternatives.
