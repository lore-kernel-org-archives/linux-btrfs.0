From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] Btrfs: fix sync subvol/snapshot creation
Date: Thu, 9 Dec 2010 18:20:44 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1012091818000.29614@cobra.newdream.net>
References: <1291941388-17050-1-git-send-email-sage@newdream.net>
 <4D018C4D.6060408@cn.fujitsu.com> <1291947062-sup-3515@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291947062-sup-3515@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 9 Dec 2010, Chris Mason wrote:
> Excerpts from Li Zefan's message of 2010-12-09 21:11:25 -0500:
> > Sage Weil wrote:
> > > We were incorrectly taking the async path even for the sync ioctls by
> > > passing in &transid unconditionally.
> > > 
> > 
> > Ha, I fixed this accidentally in my patchset. :)
>
> Thanks guys,
> 
> Unless either of you object, I'll take this and the snapshot ABI change
> for the next rc.

Sounds good to me.

Just FYI, I'm still seeing some weird corruption and crashes on my 
machines and haven't narrowed it down yet.  Should have more info soon.

sage
