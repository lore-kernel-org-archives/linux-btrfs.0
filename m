Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:55529 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab2FHI4M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2012 04:56:12 -0400
Date: Fri, 8 Jun 2012 10:28:39 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: btrfs filesystems can only be mounted after an unclean shutdown
 if btrfsck is run and immediately killed!
Message-ID: <20120608082839.GA2918@mother.jarsat.pl>
References: <4FD1B72D.3010002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <4FD1B72D.3010002@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 08, 2012 at 11:26:21AM +0300, Konstantinos Skarlatos wrote:
> Hi all,
> I have two multi-disk btrfs filesystems on a Arch linux 3.4.0
> system. After a power failure, both filesystems refuse to mount

  Multi-device filesystem had to be first fully discovered by
"btrfs device scan".  It is typically done from udev rules. Also,
dracut does it in initramfs for quite a long time.

-- 
Tomasz Torcz                        To co nierealne -- tutaj jest normalne.
xmpp: zdzichubg@chrome.pl          Ziomale na ¿ycie maj± tu patenty specjalne.

