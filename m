From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
Date: Mon, 14 Feb 2011 10:01:47 -0500
Message-ID: <1297695521-sup-9460@think>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com> <20110213161329.GL19533@dhcp231-156.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: Marti Raudsepp <marti@juffo.org>,
	btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110213161329.GL19533@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-02-13 11:13:30 -0500:
> On Sun, Feb 13, 2011 at 06:07:36PM +0200, Marti Raudsepp wrote:
> > On Sun, Feb 13, 2011 at 17:57, Josef Bacik <josef@redhat.com> wrote:
> > > Does the same problem happen when you use cp --sparse=never?
> > 
> > You are right. cp --sparse=never does not cause data loss.
> >
> 
> So fiemap probably isn't doing the right thing when compression is enabled,
> which doesn't suprise me since we don't do the right thing with delalloc either.
> I will try and get to this soon.  Thanks,

This might be a bug in the cp code.  We're setting the disk extent to
zero but setting different flags to say we're inline and compressed.
The cp fiemap code might be ignoring the flags?

Or, it could just be delalloc ;)

-chris
