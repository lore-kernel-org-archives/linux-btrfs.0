From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP
	bug?
Date: Sun, 13 Feb 2011 11:13:30 -0500
Message-ID: <20110213161329.GL19533@dhcp231-156.rdu.redhat.com>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>
To: Marti Raudsepp <marti@juffo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 13, 2011 at 06:07:36PM +0200, Marti Raudsepp wrote:
> On Sun, Feb 13, 2011 at 17:57, Josef Bacik <josef@redhat.com> wrote:
> > Does the same problem happen when you use cp --sparse=never?
> 
> You are right. cp --sparse=never does not cause data loss.
>

So fiemap probably isn't doing the right thing when compression is enabled,
which doesn't suprise me since we don't do the right thing with delalloc either.
I will try and get to this soon.  Thanks,

Josef 
