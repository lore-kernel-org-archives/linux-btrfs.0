Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753597AbdJNQsy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 12:48:54 -0400
Date: Fri, 13 Oct 2017 18:24:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/21] btrfs: switch args for comp_*_refs
Message-ID: <20171013162425.GA3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-16-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-16-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:59PM -0400, Josef Bacik wrote:
> Because seriously?  ref2 and then ref1?

Brought to you by The infamous commit 5d4f98a28c7d334091c1b with
diffstat  20 files changed, 6958 insertions(+), 2073 deletions(-) .

But we still need some description of the impact of the change, as this
effectively reverses the sorting order.
