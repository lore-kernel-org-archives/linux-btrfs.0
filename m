From: Josef Bacik <josef@redhat.com>
Subject: Re: Oops while attempting to mount degraded multi-device raid1
	data/metadata btrfs filesystem
Date: Fri, 26 Mar 2010 14:06:39 -0400
Message-ID: <20100326180639.GF6334@localhost.localdomain>
References: <93cdabd21003051219m6238b1b8nd88ca7fc3724d67a@mail.gmail.com> <93cdabd21003261049h4a468bf6ubd7bb8be1ac68d41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21003261049h4a468bf6ubd7bb8be1ac68d41@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 26, 2010 at 10:49:57AM -0700, Mike Fedyk wrote:
> I still get this oops with the latest btrfs kernel code from git (as
> of  2010-03-21) compiled against 2.6.32.9-70.fc12.x86_64
> 

Will you try this patch

[PATCH] Btrfs: fail to mount if we have problems reading the block groups

and see if it works?  Thanks,

Josef
