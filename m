Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3H3QZ4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 12:25:56 -0400
Date: Fri, 30 Aug 2013 18:25:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/15] btrfs-progs: use NULL instead of 0
Message-ID: <20130830162554.GP23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
 <1376522205-16992-16-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376522205-16992-16-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 14, 2013 at 04:16:45PM -0700, Zach Brown wrote:
> +	{ NULL, 0, NULL, 0}

> +		NULL_CMD_STRUCT,

It's always the last item, so I think the comma should go away,
currently it's mixed. I'll fix it during commit, too trivial to bother
you.

david
