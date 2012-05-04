From: David Sterba <dave@jikos.cz>
Subject: Re: Can't mount
Date: Fri, 4 May 2012 14:00:34 +0200
Message-ID: <20120504120034.GB19331@twin.jikos.cz>
References: <CAPAyKow8hk5kzAkkTG=nmOMpnhjx3cjM_-uLGNVmNWXNc+1j=g@mail.gmail.com>
 <CAPAyKowHusQXh-BzvgQRBL8=82yTgP+marcdVq8wLtSxuoCyvQ@mail.gmail.com>
 <20120503153127.GG9860@carfax.org.uk>
 <CAG1y0sc3tkkek19p_yu9qg8nTOg4YBPe6dLecC7ggVA17qVtXA@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo@carfax.org.uk>, "Yo'av Moshe" <bjesus@gmail.com>,
	linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sc3tkkek19p_yu9qg8nTOg4YBPe6dLecC7ggVA17qVtXA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2012 at 10:43:16AM +0700, Fajar A. Nugraha wrote:
> Is btrfs-zero-log still relevant? I imagine losing several last
> transactions is MUCH more convinient than having to recreate the
> enitre fs (even if restore managed to salvage everything).

IMHO it is, a few days ago this helped one user to mount his filesystem (other
usual steps to recover from unmountable filesystem did not help).

> And what about mont -o ro,recover?

I saw in the logs that the -o recovery must have been used, quoting from the
mail:

> device fsid 97727502-a678-4ed1-a96c-409b852d76bf devid 1 transid
> 135714 /dev/sda4
> btrfs: enabling auto recoveryparent transid verify failed on 216925220864 wanted 135714 found 135713
         ^^^^^^^^^^^^^^^^^^^^^^
> parent transid verify failed on 216925220864 wanted 135714 found 135713
> parent transid verify failed on 216925220864 wanted 135714 found 135713
> btrfs: open_ctree failed

and the RO mount does not make any difference here.


david
