Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbaDPPS6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 11:18:58 -0400
Date: Wed, 16 Apr 2014 17:18:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs: protect snapshots from deleting during send
Message-ID: <20140416151856.GA29256@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1397572052.git.dsterba@suse.cz>
 <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
 <534D479E.3070200@fb.com>
 <20140415154412.GU29256@twin.jikos.cz>
 <534D57B1.6090501@fb.com>
 <20140415162734.GX29256@suse.cz>
 <534D6AAA.4010709@fb.com>
 <20140416133202.GZ29256@suse.cz>
 <534E8859.4040507@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534E8859.4040507@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 09:40:41AM -0400, Chris Mason wrote:
> It makes more sense now, 'll queue this up for 3.16 and we can try it out in
> -next.

Thanks. 3.16 is fine for me.
