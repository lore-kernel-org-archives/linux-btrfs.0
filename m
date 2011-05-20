From: Chester <somethingsome2000@gmail.com>
Subject: Re: What are thoses [btrfs-cache-nnn] kernel threads ?
Date: Fri, 20 May 2011 00:32:22 -0500
Message-ID: <BANLkTimRPE-roV8JaRhQpqQW_sMtsW7Gww@mail.gmail.com>
References: <4DD4825D.4060706@polymtl.ca> <20110519182612.GD18123@dhcp231-156.rdu.redhat.com>
 <BANLkTik5vAoZrY0H=y+2v5i91x8FvsxRYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Miguel Garrido <miguel@mjgar.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTik5vAoZrY0H=y+2v5i91x8FvsxRYQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>
> Out of curiosity, why isn't this done automatically as opposed to
> having to mount with the space_cache option?

The space_cache option changes the disk format. Once enabled, it will
be permanent. The mount option gives people an option of whether they
want to enable space_cache.. I've been using it, and it's pretty safe
to use.
