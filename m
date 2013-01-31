Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab3AaQJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 11:09:22 -0500
Date: Thu, 31 Jan 2013 17:09:18 +0100
From: David Sterba <dsterba@suse.cz>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Gene Czarcinski <gene@czarc.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] Btrfs-progs: move path modification to filters
Message-ID: <20130131160918.GL30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1355235900-10252-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1301101302140.22820@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1301301432030.28271@dhcp-1-104.brq.redhat.com>
 <51096072.8010205@czarc.net>
 <alpine.LFD.2.00.1301310740110.5862@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1301310950500.14328@dhcp-1-104.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <alpine.LFD.2.00.1301310950500.14328@dhcp-1-104.brq.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 09:54:32AM +0100, Lukáš Czerner wrote:
> Just to be sure sure I have to ask. Which is the btrfs-progs repository/branch
> I should base my work on ? Currently I am using repostitory
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> 
> and master branch. Is that ok ?

No need to rebase now, there's only one easy merge conflict in 1/3.

thanks,
david
