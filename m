Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:38001 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3EEOFe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 10:05:34 -0400
Date: Sun, 5 May 2013 15:57:09 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: exploit preload daemon to defragment most needed files
Message-ID: <20130505135708.GA24548@mother.pipebreaker.pl>
References: <05mh5a-iqe.ln1@hurikhan.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <05mh5a-iqe.ln1@hurikhan.ath.cx>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 05, 2013 at 11:42:24AM +0200, Kai Krakow wrote:
> Hey list,
> 
> Although this is about the preload daemon, my intended audience for this 
> matter is the btrfs community. So I'm posting this here.
> 
> I've created a small script here[1] to read the preload daemon state file 
> and use this to run the btrfs defragmenter/compressor on these files. The 
> idea was to have some proof-of-concept to maybe integrate defragmentation 
> capabilities directly into preload.

  In similar spirit, systemd's readhead defrag files on btrfs. Here's the commit:
http://cgit.freedesktop.org/systemd/systemd/commit/?id=746f89063666be8c4d538271c646585ac4fc4353


-- 
Tomasz Torcz               "Never underestimate the bandwidth of a station
xmpp: zdzichubg@chrome.pl    wagon filled with backup tapes." -- Jim Gray

