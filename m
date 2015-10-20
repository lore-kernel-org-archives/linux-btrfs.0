Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34973 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbbJTK3H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 06:29:07 -0400
Received: by pasz6 with SMTP id z6so17875520pas.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 03:29:06 -0700 (PDT)
Date: Tue, 20 Oct 2015 18:28:00 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/10] btrfs-progs: save error number correctly in
 check_chunks_and_extents
Message-ID: <20151020082451.GA3606@dhcp-13-216.nay.redhat.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
 <1445254680-11102-3-git-send-email-guaneryu@gmail.com>
 <20151019134104.GW27761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151019134104.GW27761@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 19, 2015 at 03:41:04PM +0200, David Sterba wrote:
> On Mon, Oct 19, 2015 at 07:37:52PM +0800, Eryu Guan wrote:
> > Coverity reports assigning value from "err" to "ret", but that stored
> > value is overwritten by check_extent_refs() before it can be used.
> 
> If you fix a coverity issue, please add a tag and the id, like
> 
> Resolves-coverity-id: 1234

I was looking hard for CID but without luck.. I will ask around and see
where I can find the CIDs.

Thanks,
Eryu
