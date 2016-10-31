Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51538 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938576AbcJaQdp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 12:33:45 -0400
Date: Mon, 31 Oct 2016 17:33:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Graham Cobb <g.btrfs@cobb.uk.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: Add command to check if balance op is
 req
Message-ID: <20161031163342.GP12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-4-git-send-email-divya.indi@oracle.com>
 <c451366c-089c-5fe0-bfdb-ba3941f79d9d@cn.fujitsu.com>
 <84b80642-1c56-127c-ce1c-e38fd3bf0043@oracle.com>
 <20161028152005.GJ12522@twin.jikos.cz>
 <e0d9106a-3aa4-15df-dc97-81be7b4b687c@cobb.uk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e0d9106a-3aa4-15df-dc97-81be7b4b687c@cobb.uk.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 28, 2016 at 05:29:45PM +0100, Graham Cobb wrote:
> On 28/10/16 16:20, David Sterba wrote:
> > I tend to agree with this approach. The usecase, with some random sample
> > balance options:
> > 
> >  $ btrfs balance start --analyze -dusage=10 -musage=5 /path
> 
> Wouldn't a "balance analyze" command be better than "balance start
> --analyze"? I would have guessed the latter started the balance but
> printed some analysis as well (before or, probably more usefully,
> afterwards).

Right, separate command seems better.
