From: Billy Crook <billycrook@gmail.com>
Subject: Re: Encryption implementation like ZFS?
Date: Fri, 30 Dec 2011 13:27:43 -0600
Message-ID: <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Sandra Schlichting <littlesandra88@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 30, 2011 at 12:32, Sandra Schlichting
<littlesandra88@gmail.com> wrote:
> According to [0] ZFS does encryption:
>
> One exception to this is the encryption support being added to the ZFS
> filesystem. Filesystem metadata such as filenames, ownership, ACLs,
> extended attributes are all stored encrypted on disk. The ZFS metadata
> about the storage pool is still stored in the clear so it is possible
> to determine how many filesystems (datasets) are available in the pool
> and even which ones are encrypted but not what the content of the
> stored files or directories are.

How is this advantageous over dmcrypt-LUKS?

LUKS has always been supported between the block device and a btrfs
filesystem, and would not even let an attacker discern what type of
file-system was in use.
