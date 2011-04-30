From: Peter Stuge <peter@stuge.se>
Subject: Re: abysmal performance
Date: Sun, 1 May 2011 01:55:39 +0200
Message-ID: <20110430235539.6205.qmail@stuge.se>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Harder wrote:
> To defragment your entire volume, you'll need a command like:
> 
> # for file in $(find <PATH/TO/BTRFS/VOL/> -type f); do btrfs
> filesystem defragment ${file}; done

Suggest:

find /path/to/btrfs/vol -type f -exec btrfs filesystem defragment '{}' ';'


> If you just want to see your fragmentation you can use the 'filefrag'
> program from e2fsprogs:
> 
> # for file in $(find <PATH/TO/BTRFS/VOL/> -type f); do filefrag
> ${file}; done | sort -n -k 2 | less

find /path/to/btrfs/vol -type f -exec filefrag '{}' ';'


If either command can take multiple filenames as parameters, then e.g.:

find /path/to/btrfs/vol -type f -execdir filefrag '+'

(significantly better because not a fork per file)


//Peter
