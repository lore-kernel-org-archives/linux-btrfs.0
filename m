From: "Anthony Roberts" <btrfs-devel@arbitraryconstant.com>
Subject: Re: New feature Idea
Date: Thu, 14 Aug 2008 12:06:24 -0600 (MDT)
Message-ID: <59261.206.174.215.6.1218737184.squirrel@avalon.arbitraryconstant.com>
References: <48A320A0.80609@gmail.com> <48A32DDE.8070203@hp.com>
    <1218733937.15342.378.camel@think.oraclecorp.com>
Reply-To: btrfs-devel@arbitraryconstant.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218733937.15342.378.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> With that in said, maintaining all the machinery for dedup is definitely
> non-trivial, and I haven't yet convinced myself it wouldn't be better
> done at higher layers.  We already have the cow-single-file ioctl, why
> not have a userland process go around and create cow links between
> identical files.

Can verification + cow-single-file be done atomically with the existing
ioctl? Pushing this out into userspace seems reasonable enough, but not if
it gives a malicious user a window where they can alter part of their file
and have it CoW'd into everyone else's copy.

Is this a 1.0 feature?

