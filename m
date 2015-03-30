Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbbC3M6E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 08:58:04 -0400
Date: Mon, 30 Mar 2015 14:57:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org, Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] btrfs-progs: silence fake fsck
Message-ID: <20150330125746.GD32051@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427493523-13424-1-git-send-email-zab@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427493523-13424-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 27, 2015 at 02:58:43PM -0700, Zach Brown wrote:
> Harald suggested that we remove the message from the fake fsck.btrfs
> that some distros run at boot:
> 
>   https://bugzilla.redhat.com/show_bug.cgi?id=1206502
> 
> "This output does not add anything, but is a disturbing element of
> booting up a system. It's the only message I get, when starting my
> system, before gdm is started."
> 
> I'm inclined to agree.
> 
> This makes the tiniest change to remove the message that's output for an
> auto invocation.  My guess is that it was just copied from the xfs
> fsck.xfs and that no one actually cares about it.

That's right and I'm ok with removing it. Thanks.
