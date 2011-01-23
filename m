From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: snapshot strange behaviour
Date: Sun, 23 Jan 2011 13:17:13 +0100
Message-ID: <4D3C1C49.8040104@libero.it>
References: <ihgklr$s29$1@dough.gmane.org>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ihgklr$s29$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Lubos,

On 01/23/2011 08:17 AM, Lubos Kolouch wrote:
> Hello,
> 
> During doing backups I found strange behaviour... 2.6.37, latest btrfs-
> progs from git
> 
> nbgentoo ~ # btrfs subv crea a
> Create subvolume './a'
> nbgentoo ~ # cd a
> nbgentoo a # btrfs subv crea b
> Create subvolume './b'
> nbgentoo a # touch b/file
> nbgentoo a # ls -l b/
> total 0
> -rw-r--r-- 1 root root 0 Jan 23 08:14 file
> nbgentoo a # cd ..
> nbgentoo ~ # btrfs subv snap a x
> Create a snapshot of 'a' in './x'
> nbgentoo ~ # ls -l x/b/
> total 0
> 
> and also
> 
> nbgentoo ~ # cd x/
> nbgentoo x # btrfs subv dele b 
> ERROR: 'b' is not a subvolume
> 
> Is this a bug or intended behaviour and I am missing something something?
> How to snapshot a subvolume, containing another subvolumes?

It is the intended behavior. The snapshotting is not recursive about
subvolumes. If you snapshot a subvolume which contains another one, you
got only the content of the first subvolume.
The directory "x/b" which you see, is not the subvolume "b" snapshotted,
but only the "mount-point" of "b".


> 
> (I create subvolume backup, under this another subvolumes as not always I 
> want to snapshot the whole backup subvolume).
> 
> Thank you
> 
> Lubos
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

