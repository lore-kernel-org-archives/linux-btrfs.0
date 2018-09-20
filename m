Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732356AbeITXH1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 19:07:27 -0400
Date: Thu, 20 Sep 2018 19:22:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 0/6] Btrfs: implement swap file support
Message-ID: <20180920172255.GE5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1537419652.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1537419652.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 10:02:11PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> Changes from v7 [1]:
> 
> - Expanded a few commit messages
> - Added Johannes' acked-by on patches 1 and 2
> - Rebased on v4.19-rc4

I've sent my comments, it's mostly about the usability or small
enhancements. As you've got acks from MM people, I hope it would be ok
if I add this series to for-next so we can give it some testing.

The MM patches would better go separately to 4.20 via the mm tree.  I
did only build tests so 4.20 target is still feasible but given that
it's rc4 it's a bit too close. There are some limitations posed by the
swapfiles so I'd like to have a chance to do some actual tests myself
and check the usability status.
