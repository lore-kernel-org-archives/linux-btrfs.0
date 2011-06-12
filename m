From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: cannot remove files: No space left on device
Date: Sun, 12 Jun 2011 11:48:38 +0200
Message-ID: <4DF48B76.4010008@wpkg.org>
References: <4DF3FB15.1040108@wpkg.org> <BANLkTinUKfYwGT0iaig5072bQ33AgRuQ5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: Mike Fleetwood <mike.fleetwood@googlemail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinUKfYwGT0iaig5072bQ33AgRuQ5g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12.06.2011 10:27, Mike Fleetwood wrote:

> Check out the btrfs FAQ about space usage:
>    https://btrfs.wiki.kernel.org/index.php/FAQ#Why_are_there_so_many_ways_to_check_the_amount_of_free_space.3F
>
> and try these command too:
>   btrfs filesystem df /mnt/btrfs
>   btrfs filesystem show /dev/sdb4
>
> I'm no btrfs expert but it's worth trying to delete one file and
> syncing the fs, then repeating.

Yes, I know this FAQ.

I've deleted around 40 GB files, but still occasionally see "No space 
left on device" when removing files, or when copying new files to btrfs 
filesystem (i.e. copying one file fails with "No space left on the 
device", while there is ~70 GB free on btrfs filesystem; and copying 
some other files, with similar or bigger size, succeeds).


-- 
Tomasz Chmielewski
http://wpkg.org
