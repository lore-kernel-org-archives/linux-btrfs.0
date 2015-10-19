Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbbJSOXF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 10:23:05 -0400
Date: Mon, 19 Oct 2015 16:21:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] btrfs-progs: fix leak of "path" in
 btrfs_find_item() error paths
Message-ID: <20151019142151.GA27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've merged 1, 2 (the first one), 7, 8, 9 and 10. Please add the missing
coverity references and resend. The remaining patches seem unnecessary
but please check whether I haven't missed something.
