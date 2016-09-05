Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43763 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753456AbcIEH31 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Sep 2016 03:29:27 -0400
Date: Mon, 5 Sep 2016 09:27:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: gazillions of Incorrect local/global backref count
Message-ID: <20160905072757.GW16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1472964653.8683.17.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472964653.8683.17.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 04, 2016 at 06:50:53AM +0200, Christoph Anton Mitterer wrote:
> Hey.
> 
> I just did a btrfs check on my notebooks root fs, with:
> $ uname -a
> Linux heisenberg 4.7.0-1-amd64 #1 SMP Debian 4.7.2-1 (2016-08-28)
> x86_64 GNU/Linux
> $ btrfs --version
> btrfs-progs v4.7.1

As others replied, it's a false positive. There's a fix on the way, once
it's done I'll release 4.7.2.
