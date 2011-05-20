From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What are thoses [btrfs-cache-nnn] kernel threads ?
Date: Fri, 20 May 2011 07:22:03 -0400
Message-ID: <1305890412-sup-1052@shiny>
References: <4DD4825D.4060706@polymtl.ca> <20110519182612.GD18123@dhcp231-156.rdu.redhat.com> <BANLkTik5vAoZrY0H=y+2v5i91x8FvsxRYQ@mail.gmail.com> <BANLkTimRPE-roV8JaRhQpqQW_sMtsW7Gww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Miguel Garrido <miguel@mjgar.com>, Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTimRPE-roV8JaRhQpqQW_sMtsW7Gww@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chester's message of 2011-05-20 01:32:22 -0400:
> >
> > Out of curiosity, why isn't this done automatically as opposed to
> > having to mount with the space_cache option?
> 
> The space_cache option changes the disk format. Once enabled, it will
> be permanent. The mount option gives people an option of whether they
> want to enable space_cache.. I've been using it, and it's pretty safe
> to use.

Once enabled it does stay on, and strictly speaking it does change the
disk format.  But, it is perfectly safe to go back to a non-space_cache
enabled kernel and then go back into space cache.  Josef set things up
so it would detect a non-space_cache mount and continue properly.

space_cache is wonderful.  We did fix up a few bugs in .38 and .39 but
I'll probably have .40 enable it by default.

-chris
