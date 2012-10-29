Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:35105 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2J2MmC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 08:42:02 -0400
Date: Mon, 29 Oct 2012 13:33:13 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Old (almost 2 years) btrfs failed fs. Parent transid failure.
 Can it be fixed ?
Message-ID: <20121029123313.GA19012@mother.jarsat.pl>
References: <CAM4M9rQZbsmiC_xmjAtt+syEmp5_ABMTmSVK0KAoVJwc2yqTwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM4M9rQZbsmiC_xmjAtt+syEmp5_ABMTmSVK0KAoVJwc2yqTwg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 29, 2012 at 01:22:59PM +0100, Tommy Jonsson wrote:
> Hi, i have an old btrfs file-system that crashed on a power-failure
> for about 2 years ago.
> 
> i have clone the
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> (at 2012-10-29) and compiled the tools.

  I think you need to get branch "dangerdonoteveruse" to get real fsck code.
 
> sudo mount -t btrfs /dev/sda /mnt/disk/

 Could you try with "-o recovery"?

-- 
Tomasz Torcz                                                       72->|   80->|
xmpp: zdzichubg@chrome.pl                                          72->|   80->|

