Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:48706 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3EGFRp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 01:17:45 -0400
Date: Tue, 7 May 2013 07:17:42 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Message-ID: <20130507051741.GB24548@mother.pipebreaker.pl>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
 <gqgl5a-4s5.ln1@hurikhan.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <gqgl5a-4s5.ln1@hurikhan.ath.cx>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 06, 2013 at 10:36:03PM +0200, Kai Krakow wrote:
> zwu.kernel@gmail.com <zwu.kernel@gmail.com> schrieb:
> 
> >   The patchset is trying to introduce hot relocation support
> > for BTRFS. In hybrid storage environment, when the data in
> > HDD disk get hot, it can be relocated to SSD disk by BTRFS
> > hot relocation support automatically; also, if SSD disk ratio
> > exceed its upper threshold, the data which get cold can be
> > looked up and relocated to HDD disk to make more space in SSD
> > disk at first, and then the data which get hot will be relocated
> > to SSD disk automatically.
> 
> How will it compare to bcache? I'm currently thinking about buying an SSD 
> but bcache requires some efforts in migrating the storage to use. And after 
> all those hassles I am even not sure if it would work easily with a dracut 
> generated initramfs.

  On the side note: dm-cache, which is already in-kernel, do not need to
reformat backing storage.

-- 
Tomasz Torcz                Only gods can safely risk perfection,
xmpp: zdzichubg@chrome.pl     it's a dangerous thing for a man.  -- Alia

