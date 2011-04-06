From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: files on not mounted subvolumes - mysql complains read only
Date: Wed, 06 Apr 2011 09:31:12 +0800
Message-ID: <4D9BC260.6050508@cn.fujitsu.com>
References: <BANLkTimON46Jquhy2-4RQHCL+Vi-BGy1UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com" <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimON46Jquhy2-4RQHCL+Vi-BGy1UA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

krzf83@gmail.com wrote:
> When I've used btrfs subvolume, without separately mouting it, for
> mysql database dir I've got
> Fatal error: Can't open and lock privilege tables: Table 'host' is read only
> when starting mysql. When I've put mysql database dir in root of
> btrfs, not a subvolume, mysql works fine.
> I've checked file for host table, but I could write to it no problem
> (on subvolume without mouting). I dont know what could be the problem.
> I did not check it when mouting a subvolume separately

This has been fixed. You can pull the for-linus branch of the btrfs-unstable
tree, or Linus' linux-2.6, or wait for v2.6.39-rc2 to be announced.
