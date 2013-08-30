Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab3H3Qbj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 12:31:39 -0400
Date: Fri, 30 Aug 2013 18:31:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs-progs: fix sparse checking and warnings
Message-ID: <20130830163138.GQ23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I went through the actual fixes and they're selfcontained and now in
integration. Actually, the compilation fail in 1/1 might be caused by a
old sparse utility on my box, I'll check again later.

thanks,
david
