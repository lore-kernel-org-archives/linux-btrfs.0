Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbbDQRek (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 13:34:40 -0400
Date: Fri, 17 Apr 2015 19:34:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: dsterba@suse.cz,
        Lauri =?iso-8859-1?Q?V=F5sandi?= <lauri.vosandi@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: enforce chroot for btrfs receive
Message-ID: <20150417173438.GU25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <217a387d55b5828a82fadad98dd88a959e7a13ed.1429008167.git.lauri.vosandi@gmail.com>
 <20150414122810.GN25622@twin.jikos.cz>
 <552D13D0.2030205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <552D13D0.2030205@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 14, 2015 at 09:19:12AM -0400, Austin S Hemmelgarn wrote:
> On 2015-04-14 08:28, David Sterba wrote:
> > On Tue, Apr 14, 2015 at 01:44:32PM +0300, Lauri Võsandi wrote:
> >> This patch forces btrfs receive to issue chroot before
> >> parsing the btrfs stream to confine the process and
> >> minimize damage that could be done via malicious
> >> btrfs stream.
> >
> > Thanks.
> >
> > As we've discussed, there are possibly some things to resolve:
> >
> > * chdir("/") after chroot
> > * commandline options to enable/disable chroot, choose the default
> >
> > Receive should work for a non-root user so chroot should be conditional,
> > but I'm not sure if this should be guessed from the UID or if this would
> > be better to specify only by the commandline options.
> >
> > I'll put the patch into a separate branch for now.
> 
> Personally, I would expect it to default to not using chroot(), provide 
> a commandline option to tell it to do so, and then just catch the error 
> from trying to chroot as a non-root user.

Thanks, I agree with that.
