Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbbLGPhh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 10:37:37 -0500
Date: Mon, 7 Dec 2015 16:35:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs-progs: fix file restore to lost+found bug
Message-ID: <20151207153538.GG4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449207447-1203-1-git-send-email-naota@elisp.net>
 <56623F4B.80502@gmx.com>
 <CAEe67=-3o9Roe7ewHRQqWnSe+HjVc22-_6FObHy2PeTwZXAcSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEe67=-3o9Roe7ewHRQqWnSe+HjVc22-_6FObHy2PeTwZXAcSQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 07, 2015 at 11:59:19AM +0900, Naohiro Aota wrote:
> > But I only see the first 2 patches in maillist...
> > The last test case seems missing?
> 
> Maybe, the last patch is too large to post to the list? Even it get
> smaller, 130260 bytes seems to be a bit large.
> 
> How should I handle this? Put my repo somewhere and wait a maintainer
> to pull it?

Please send it to me directly. The image will be available in
btrfs-progs git and we don't necessarily need the copy in the
mailinglist.
