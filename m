From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
Date: Mon, 14 Feb 2011 13:01:32 -0500
Message-ID: <1297706458-sup-9378@think>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com> <20110213161329.GL19533@dhcp231-156.rdu.redhat.com> <1297695521-sup-9460@think> <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>
To: Marti Raudsepp <marti@juffo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Marti Raudsepp's message of 2011-02-14 12:58:17 -0500:
> On Mon, Feb 14, 2011 at 17:01, Chris Mason <chris.mason@oracle.com> wrote:
> > Or, it could just be delalloc ;)
> 
> I suspect delalloc. After creating the file, filefrag reports "1
> extent found", but for some reason it doesn't actually print out
> details of the extent.
> 
> After a "sync" call, the extent appears and "cp" starts working as expected:

Great, that's a ton easier than fixing cp.

-chris
