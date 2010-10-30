From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 2/3] btrfs: implement 'async-snapshot' command
Date: Sat, 30 Oct 2010 20:35:05 +0200
Message-ID: <201010302035.05962.kreijack@libero.it>
References: <1288461366-26914-1-git-send-email-sage@newdream.net> <1288461366-26914-2-git-send-email-sage@newdream.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288461366-26914-2-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 30 October, 2010, Sage Weil wrote:
> This is identical to 'snapshot', but uses the new async snapshot creation
> ioctl, and prints out the transid the new snapshot will be committed
> with.

Only for curiosity, how long may take snapshot a tree ? It should be only a 
copy and update of few pages on the disk (the head of the trees), so the time 
should be O(1)...

Goffredo

[...]
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
