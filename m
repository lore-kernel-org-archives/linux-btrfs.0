Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:48039 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaHXRdA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 13:33:00 -0400
Date: Sun, 24 Aug 2014 19:32:56 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: REPORT: Still a lot of BTRFS freezes in 3.16.1-1-ARCH
Message-ID: <20140824173255.GB367827@mother.pipebreaker.pl>
References: <4207113.A3bnH6gnWF@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4207113.A3bnH6gnWF@zafu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 24, 2014 at 07:25:43PM +0200, Swâmi Petaramesh wrote:
> Hi there,
> 
> This is to report that I'm still having quite systematic BRTFS freezes on an 
> ArchLinux running latest 3.16.1-1-ARCH kernel.
> 
> Interestingly enough, I have several latops with the exact same setup :
> 
> Arch Linux with 3.16.1-1-ARCH kernel, fully running on BTRFS (with LZO 
> compression) over LVM over LUKS.

  Have you applied Liu's patch[1]?  It not useful reporting knows bugs, if
you haven't.

 1 – http://www.spinics.net/lists/linux-btrfs/msg36616.html

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|

