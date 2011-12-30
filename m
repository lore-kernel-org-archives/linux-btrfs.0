From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: Encryption implementation like ZFS?
Date: Fri, 30 Dec 2011 23:10:19 +0100
Message-ID: <20111230221019.GA7888@mother.jarsat.pl>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
 <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 30, 2011 at 01:27:43PM -0600, Billy Crook wrote:
> On Fri, Dec 30, 2011 at 12:32, Sandra Schlichting
> <littlesandra88@gmail.com> wrote:
> > According to [0] ZFS does encryption:
> >
> > One exception to this is the encryption support being added to the ZFS
> > filesystem. Filesystem metadata such as filenames, ownership, ACLs,
> > extended attributes are all stored encrypted on disk. The ZFS metadata
> > about the storage pool is still stored in the clear so it is possible
> > to determine how many filesystems (datasets) are available in the pool
> > and even which ones are encrypted but not what the content of the
> > stored files or directories are.
> 
> How is this advantageous over dmcrypt-LUKS?

  For example mixing encrypted and not encrypted subvolumes in one pool.
And not having to separately cryptsetup luksOpen all disks consisting filesystem.
  There are advantages of FDE like dm-crypt and selective encryption like in ZFS.

-- 
Tomasz Torcz               RIP is irrevelant. Spoofing is futile.
xmpp: zdzichubg@chrome.pl     Your routes will be aggreggated. -- Alex Yuriev

