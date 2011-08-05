From: Yuri D'Elia <wavexx@users.sf.net>
Subject: Re: BTRFS partition won't mount
Date: Fri, 5 Aug 2011 10:20:47 +0200
Message-ID: <20110805102047.d9d80eec4ef78972eac3fd4d@users.sf.net>
References: <1F6ED4EA7957EB4FADAE461E036D456A25D75644F9@exch01lex.ceradyne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 3 Aug 2011 16:46:01 -0400
Adam Newby <anewby@ceradyne.com> wrote:

> Hello all,
> 
> I recently had a power failure and can no longer mount my /home directory. The harddrive has two BTRFS partitions: sda7(/) and sda8(/home). The / partition loads up just fine, but /home does not. I've tried btrfsck as shown below and I've included dmesg pertaining to btrfs. This is on ArchLinux and the software versions are as follows:
> btrfs-progs-unstable 0.19.20101006-1
> linux 3.0

Just a question here: how come corruption after power loss is *so* common by reading this list? I mean, are there some/hidden journal flushing issues that lead to this or what?

I tried to cycle my testing machines several times to test the fs consistency months ago and I never had any corruption issues so far, but it seems I just could be lucky.

