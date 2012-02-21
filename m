From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: avoid setting ->d_op twice
Date: Tue, 21 Feb 2012 15:52:29 +0100
Message-ID: <20120221145229.GI1046@twin.jikos.cz>
References: <4F435E1C.8090902@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F435E1C.8090902@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks for the patch!

On Tue, Feb 21, 2012 at 05:04:28PM +0800, Li Zefan wrote:
> Follow those instructions, and you'll trigger a warning in the
> beginning of d_set_d_op():
> 
>   # mkfs.btrfs /dev/loop3
>   # mount /dev/loop3 /mnt
>   # btrfs sub create /mnt/sub
>   # btrfs sub snap /mnt /mnt/snap
>   # touch /mnt/snap/sub
>   touch: cannot touch `tmp': Permission denied

is this the right error code? permission denied == EACCESS and this is
returned in case of file

(strace touch file)

open("file", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) = -1 EACCES (Permission denied)

while mkdir returns (strace mkdir a-dir)

mkdir("a-dir", 0777)                    = -1 EPERM (Operation not permitted)


The commands were run as root and EPERM looks more adequate than
EACCESS.


david
