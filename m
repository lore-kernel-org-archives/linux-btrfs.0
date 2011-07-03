From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: will mkfs.btrfs do an initial pre-discard for SSDs like mke2fs
 does for Ext4?
Date: Sun, 3 Jul 2011 18:53:16 +0700
Message-ID: <CAG1y0sedLGaajXEPGo=dFjUjufko08CBrJTihH1Xa5AVR6FoJQ@mail.gmail.com>
References: <1309690813.2987.8.camel@werner-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Werner Fischer <devlists@wefi.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309690813.2987.8.camel@werner-t410>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 3, 2011 at 6:00 PM, Werner Fischer <devlists@wefi.net> wrote:
> Hi all,
>
> are there any plans that future versions of mkfs.btrfs will do an
> initial pre-discard for SSDs? (AFAIK mkfs.btrfs does not do this
> currently)

It should already have it. That is, if you look in the right place

commit e6bd18d8938986c997c45f0ea95b221d4edec095
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Apr 21 16:24:07 2011 -0400

    btrfs-progs: add discard support to mkfs

    Discard the whole device before starting to create the filesystem
structures.
    Modelled after similar support in mkfs.xfs.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

IIRC it's already in tmp branch of Chris' btrfs-progs-unstable, but
not in master (yet).

-- 
Fajar
