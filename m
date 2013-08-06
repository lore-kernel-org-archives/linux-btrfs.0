Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab3HFPNc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 11:13:32 -0400
Date: Tue, 6 Aug 2013 17:13:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] Btrfs-progs: add missing man page information for
 btrfsck
Message-ID: <20130806151329.GK5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 01, 2013 at 01:35:25PM +0800, Wang Shilong wrote:
> +.SH COPYRIGHT
> +Copyright \(co 2013 Fujitsu, Inc.
> +License GPLv3: GNU GPL version 3 <http://gnu.org/licenses/gpl.html>.
> +.br
> +This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.

Are you sure you want both a copyright statement and GPL wording here?

Another quiestion is about the GPL version itself, you're releasing it
under v3 but the rest of the code is under v2 and there are issues when
these licenses are mixed.

I'd like to avoid any flames about v2 vs v3, so for ease of maintenance
please either drop the section or change it to gplv2. You're free to
insist on v3, then I'm not going to merge the patches.

thanks,
david
