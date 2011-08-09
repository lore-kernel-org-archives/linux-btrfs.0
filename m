From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: =?utf-8?Q?=E2=80=9Cbio?= too =?utf-8?Q?big=E2=80=9D?=
 regression and silent data corruption in 3.0
Date: Tue, 09 Aug 2011 01:04:27 -0300
Message-ID: <orobzz5iyc.fsf@livre.localdomain>
References: <orwreobtuf.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orwreobtuf.fsf@livre.localdomain> (Alexandre Oliva's message of
	"Sun, 07 Aug 2011 22:00:24 -0300")
List-ID: <linux-btrfs.vger.kernel.org>

On Aug  7, 2011, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:

> in very much the same way that it appears to be impossible to go
> back from RAID1 to DUP metadata once you temporarily add a second disk,
> and any metadata block group happens to be allocated before you remove
> it (why couldn't it go back to DUP, rather than refusing the removal
> outright, which prevents even single block groups from being moved?)

Which also appears to be intentional.  The code to suport this is right
there in update_block_group_flags, but btrfs_rm_device refuses to let it
do its job, denying the removal attempt right away, without any means to
bypass the test.  Could at least an option to bypass the test be
introduced, through say a mount option, some /sys setting, whatever?

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
