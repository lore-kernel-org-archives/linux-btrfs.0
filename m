Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbbFYNlw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 09:41:52 -0400
Date: Thu, 25 Jun 2015 15:41:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs device remove alias
Message-ID: <20150625134151.GH726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1435161735.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1435161735.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2015 at 09:09:15AM -0700, Omar Sandoval wrote:
> The opposite of btrfs device add is btrfs device delete. This really
> should be btrfs device remove.

I think people got used to the 'delete' command over time, but for
convenience I don't mind to add the alias. Also you delete files by 'rm'
which is short for 'remove' and probably don't mind either.
