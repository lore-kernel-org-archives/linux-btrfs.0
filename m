From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [RFC] btrfs send and receive
Date: Mon, 01 Aug 2011 20:51:36 +0200
Message-ID: <4E36F5B8.5090803@libero.it>
References: <4E369A80.9030307@jan-o-sch.net>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E369A80.9030307@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan

On 08/01/2011 02:22 PM, Jan Schmidt wrote:

> I furthermore realized that the term "subvolume" is omitted in favor >
of the term "snapshot". This is because I tend to think of snapshots
> being read-only (though I very much appreciate they are not). Just
> replace the term wherever you feel appropriate.

I think that we have to cope to both the terms. A snapshot is a
subvolume with an ancestor. This is important if we want to be able to
"transfer" between two filesystem a snapshot as subvolume + delta.



> 3) KEY PROPERTIES
> 
> I wrote down key features that are must haves for me, please add to the
> list if you have anything on top:
> 
> - "send" must generate a stream that can either be "receive"d
>   immediately or stored in a file for asynchronous "receive"
> - streams must obviously be byte order safe
> - a stream must contain a complete fs (full stream) or an incremental
>   update to a file system
> - a stream must not be restricted in size
> - an incremental stream must contain the information which version it
>   is based on
> - "receive" of an incremental stream must check whether the base is
>   the current state of the file system
>     - YES => "receive"
>     - NO, but is previous version
>       => abort; should offer --force for rollback and "receive"
>     - NO, does not match any previous version => abort
> - a stream must be taken from a consistent state of the file system
> - the source file system must remain read-writable during a "send"
> - the destination file system must at least remain readable during a
>   "receive"
> - btrfs as a destination file system should reflect all features of
>   the source file system

I think that we should define what means "all features".

1) If we are interested to transport only the file
type/contents/timestamps/acls/owners/permissions, that could be obtained
with a combination of "find-new" (with some extensions [1]) and an
user-space tool. No extension to BTRFS are needed.

1.1) as above plus preserve the inode number.

2) If we want to have also to conserver the COW relation (between
snapshots/subvolumes and  files), I think that we need some help from
the kernel side to be able to injecting these information in the
destination btrfs filesystem.
Moreover we need to cope all the possible errors due to the fact that
the snapshot/subvolume are out-sync between the source fs and the
destination fs: what about if we want to transport a snapshot to an
another filesystem where the snapshotted subvolume (previously
successful transported) was removed or changed ? How we can check if a
snapshot/subvolume was changed ?


> - other destination file systems must be supported (although some
>   features will not map to all file systems)


BR
G.Baroncelli


[1] http://comments.gmane.org/gmane.comp.file-systems.btrfs/8201

