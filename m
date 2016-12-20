Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752252AbcLTQ0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 11:26:01 -0500
Date: Tue, 20 Dec 2016 17:25:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Seraphime Kirkovski <kirkseraph@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jbacik@fb.com, clm@fb.com
Subject: Re: [PATCH 2/4] Btrfs: coding style fixes
Message-ID: <20161220162545.GN3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161215133805.25681-1-kirkseraph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161215133805.25681-1-kirkseraph@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 15, 2016 at 02:38:05PM +0100, Seraphime Kirkovski wrote:
> This eliminates the rare uses of `unsigned` instead of `unsigned int`.

As far as I'm concerned, I don't like this change. It's fine to
encourage 'unsigned int' in new code, but changing the existing ones
does not sound very useful to me as there's no common preference among
the developers.
