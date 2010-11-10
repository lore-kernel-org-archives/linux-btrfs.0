From: William Uther <willu.mailingLists@cse.unsw.edu.au>
Subject: Re: btrfs filesystem defragment error
Date: Wed, 10 Nov 2010 11:08:01 +1100
Message-ID: <D58BED37-15FF-41C9-ADD5-6AF3BAC64EF7@cse.unsw.edu.au>
References: <AANLkTikjgmNmuEz2k-vm-f-O2roaC0+z1p7tNZT-poea@mail.gmail.com> <AANLkTi=WgPRafvAUUsrNydLPuz4JEjW3DNLNHYSAbAj5@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=WgPRafvAUUsrNydLPuz4JEjW3DNLNHYSAbAj5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


> You need to run it as root (via sudo or whatever).  On the other hand,
> it probably doesn't work like you think it does, and you probably
> don't want to defrag anyway :p
> 
> btrfs fi defrag takes a file or folder, and defrags just that file or
> folder (i.e., no recursion).

Quick question about defrag: is it safe to use it on an open file?

Thanks,

Will       :-}

