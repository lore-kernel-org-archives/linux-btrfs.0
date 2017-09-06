Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43593 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754901AbdIFPwd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 11:52:33 -0400
Date: Wed, 6 Sep 2017 17:51:04 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: test: fix name generation not to
 contain trailing spaces
Message-ID: <20170906155104.GY31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <64ab304a-6b5f-d2ac-3b74-90952371404e@jp.fujitsu.com>
 <c27eb6e9-4a07-12c5-acd6-76229b2a7103@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c27eb6e9-4a07-12c5-acd6-76229b2a7103@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 05, 2017 at 02:50:03PM +0900, Misono, Tomohiro wrote:
> First patch causes test-convert fails.  This is because
> generate_dataset() creates a name containing trailing spaces for
> "slow_symlink" type, and cause getfacl error in convert_test_perm().
> (This is not noticed since original run_check_stdout() throws away the
> error.)
> 
> Fix this by use space for delimiter for cut.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Both applied, thanks.
