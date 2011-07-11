From: Tarkan Erimer <tarkan@turknetserver.com>
Subject: Re: [GIT PULL] btrfs fixes
Date: Mon, 11 Jul 2011 14:31:50 +0300
Message-ID: <4E1ADF26.10605@turknetserver.com>
References: <1310151138-sup-6548@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1310151138-sup-6548@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/08/2011 09:55 PM, Chris Mason wrote:
> Hi everyone,
>
> The for-linus branch of the btrfs-unstable repo:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus
>
> Has three more fixes.  We're fixing oopsen during space balancing (btrfs
> filesystem balance /mnt)) and during device removal.
>
> Dave Sterba also sent in a patch to make /proc/mounts properly match a
> few new mount options, which he (correctly I think) considers a
> regression fix because it makes it hard for testers/users to verify the
> options in a running config.
>

Hi Chris,

Maybe, any development regarding to the "[BUG] Btrfs: Corrupted root 
filesystem" subjected bug posted by me ?


Tarkan
