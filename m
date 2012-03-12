From: David Sterba <dave@jikos.cz>
Subject: Re: immutable (WORM) file system
Date: Tue, 13 Mar 2012 00:40:39 +0100
Message-ID: <20120312234039.GA13695@twin.jikos.cz>
References: <CAP7LQsLiDC8Y=g+ocQGYdC-4LdpDWs9QkL+PvMD311wR2UY0GQ@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Fong Vang <sudoyang@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAP7LQsLiDC8Y=g+ocQGYdC-4LdpDWs9QkL+PvMD311wR2UY0GQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 12, 2012 at 12:36:13PM -0700, Fong Vang wrote:
> Does anyone know if there's a plan to provide an option to make a
> BTRFS filesystem a WORM (write-one-read-many)? =A0So essentially, onc=
e a
> file has been written it cannot be altered nor deleted. =A0To delete
> would require a newfs. =A0I know that there's extended attributes but
> root can alter that on individual files.

There's a btrfs-specific per-inode flag BTRFS_INODE_READONLY, it is use=
d
in just one place (to check inode permissions upon write) and denies an=
y
write operation. There's no direct way (like an ioctl call) to either
add or remove this flag, so it fullfils one half of what you want.

It's possible to enhance mkfs to set this flag to all files when
prefilled from a directory (option -r). For a change in a mounted
filesystem, a new ioctl doing the one-way switch to RO would be needed.

(I just know that the flag is there and is related to the question,
haven't tested it myself and do not know what was the original
intention.)


david
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
