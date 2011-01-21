From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: btrfs subvolume list fails to show all snapshots
Date: Fri, 21 Jan 2011 10:03:55 +0800
Message-ID: <4D38E98B.8090901@cn.fujitsu.com>
References: <20101212034339.GA26170@idallen.ca> <20101212081359.GA7389@idallen.ca> <20101212094517.GA19181@idallen.ca> <4D05DD9A.2060206@cn.fujitsu.com> <20110120230127.GB4161@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Ian! D. Allen" <idallen@idallen.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110120230127.GB4161@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

07:01, Ian! D. Allen wrote:
> Still getting "btrfs subvolume list" errors with this source:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> 

Just because the fix hasn't been merged into the git tree..

> I create ten snapshots, and after creating the tenth one, the sixth one
> disappears from "btrfs subvolume list":
