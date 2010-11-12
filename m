From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2 2/2] Cancel filesystem balance.
Date: Fri, 12 Nov 2010 09:33:37 +0800
Message-ID: <4CDC9971.6080903@cn.fujitsu.com>
References: <cover.1289522188.git.hugo@carfax.org.uk> <9b18b334410714aba2867f96e949f19243536ddc.1289522188.git.hugo@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9b18b334410714aba2867f96e949f19243536ddc.1289522188.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills wrote:
> This patch adds an ioctl for cancelling a btrfs balance operation
> mid-flight. The ioctl simply sets a flag, and the operation terminates
> after the current block group move has completed.
> 

Is there any blocker that prevents us from canceling balance
by just Ctrl+C ?

> Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> ---
>  fs/btrfs/ctree.h   |    1 +
>  fs/btrfs/ioctl.c   |   28 ++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h   |    3 ++-
>  fs/btrfs/volumes.c |    7 ++++++-
>  4 files changed, 37 insertions(+), 2 deletions(-)
