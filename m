Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53599 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752690AbeENNsJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 09:48:09 -0400
Date: Mon, 14 May 2018 15:45:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: robbieko <robbieko@synology.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v3] btrfs: incremental send, fix BUG when invalid memory
 access
Message-ID: <20180514134527.GI6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526266294-23121-1-git-send-email-robbieko@synology.com>
 <CAL3q7H6u-cH+zKnUkMgC-O_eWAhP4JvxOMR=b+szk5SYCo1cFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6u-cH+zKnUkMgC-O_eWAhP4JvxOMR=b+szk5SYCo1cFQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 12:39:36PM +0100, Filipe Manana wrote:
> On Mon, May 14, 2018 at 3:51 AM, robbieko <robbieko@synology.com> wrote:
> > Signed-off-by: Robbie Ko <robbieko@synology.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Looks good, I would only change the subject to something like:
> 
> Btrfs: send, fix invalid access to commit roots due to concurrent snapshotting
> 
> David can probably do that when picking this patch.

Patch updated, thank you both.
