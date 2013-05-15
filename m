Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:55978 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab3EOS5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 14:57:39 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <axboe@kernel.dk>
Subject: Re: I/O errors block the entire filesystem
References: <orhajmb7kc.fsf@livre.home> <orhaiax9yh.fsf@livre.home>
	<20130515135326.GD1765@localhost.localdomain>
Date: Wed, 15 May 2013 15:56:48 -0300
In-Reply-To: <20130515135326.GD1765@localhost.localdomain> (Josef Bacik's
	message of "Wed, 15 May 2013 09:53:26 -0400")
Message-ID: <or61ykqdfz.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 15, 2013, Josef Bacik <jbacik@fusionio.com> wrote:

> So this should only happen in the case that you are on a dm device it looks
> like, is that how you are running?

That was my first thought, but no, I'm using partitions out of the SATA
disks directly.  I even checked for stray dm out of fake raid or
somesuch, but the dm modules were not even loaded, and perusing
/sys/block confirms the “scsi” devices are actual ATA disks.

Further investigation suggested that when individual 512-byte blocks are
read from a disk (that's the block size reported by the kernel), the
underlying disk driver is supposed to inform the upper layer about what
it could read by updating the bio_vec bits in precisely the observed
way.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
