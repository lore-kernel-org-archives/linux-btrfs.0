From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 20:01:17 +0200
Message-ID: <201005182001.17354.kreijack@libero.it>
References: <4BF18525.8080904@gmail.com> <4BF2B8FD.10301@gmail.com> <20100518161013.GD8635@think>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100518161013.GD8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, May 18, 2010, Chris Mason wrote:
> On Tue, May 18, 2010 at 05:57:49PM +0200, Jakob Unterwurzacher wrote:
> > On 18/05/10 16:36, Chris Mason wrote:
[...]
> > 
> > I thought the problem of delaying the renames was complexity, well, at
> > least T'Tso said it was [1] - I'm not sure if this applies to btrfs as 
well.
> 
> I'm afraid there are lots and lots of different issues at play.  The
> most important way to look at it is that forcing data to disk is very
> slow, which is why we try to avoid it whenever we can.
> 
> Applications can request that the data go to disk via lots of different
> ways.  Rename was never ever meant to be one of them, but it really does
> make sense to provide atomic replacement of old good data with new good
> data, so we've implemented that extra syncing.
> 
> Implementing syncing when userland doesn't expect extra syncing usually
> just make userland very unhappy.  It's not that we can't do it it's that
> doing it has implications for every application that uses rename.
> 
> -chris


Funny, the first thing that comes to my mind reading this thread, is that this 
kind of complaint is raised about a file-system which is able to support a 
full rollback via the snapshot. 

I think that a "right" solution should be to integrate the package manager 
with the btrfs snapshot capability (as nexenta does [1]). But it is clear that 
this is a long term solution (IIRC Fedora is working on this).

In the mean time, which should be the "right" solution to solve the dpkg 
problem ( and in a more general form the package manager problem) with btrfs ?

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

[1] http://www.nexenta.org/os/TransactionalZFSUpgrades

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
