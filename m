From: "Niels de Carpentier" <niels@decarpentier.com>
Subject: Re: Encryption implementation like ZFS?
Date: Sat, 31 Dec 2011 04:36:56 +0100
Message-ID: <e06db8e10a1db43cb127340b25436b59.squirrel@webmail.decarpentier.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
    <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
    <20111230221019.GA7888@mother.jarsat.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111230221019.GA7888@mother.jarsat.pl>
List-ID: <linux-btrfs.vger.kernel.org>

>> How is this advantageous over dmcrypt-LUKS?
>
>   For example mixing encrypted and not encrypted subvolumes in one pool.
> And not having to separately cryptsetup luksOpen all disks consisting
> filesystem.
>   There are advantages of FDE like dm-crypt and selective encryption like
> in ZFS.

I think there were possible problems with btrfs on dm-crypt before, which
was suspected to due to write barrier issues of dm-crypt. Has this been
fixed?

Niels



