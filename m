Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933609Ab3HGWCb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 18:02:31 -0400
Message-ID: <5202C3EF.4090501@redhat.com>
Date: Wed, 07 Aug 2013 17:02:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 0/7] uselex.rb as a tiny tool to find dead code
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
In-Reply-To: <1375911803-17318-1-git-send-email-slyich@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/7/13 4:43 PM, Sergei Trofimovich wrote:

...

> Meet uselex.rb: one-file script to parse 'nm' output:
> 
>     https://github.com/trofi/uselex/blob/master/uselex.rb

Nice to meet you!  I think I've met your close relative,
ftp://ftp.samba.org/pub/unpacked/junkcode/findstatic.pl  :)

#!/usr/bin/perl -w
# find a list of fns and variables in the code that could be static
# usually called with something like this:
#    findstatic.pl `find . -name "*.o"`
# Andrew Tridgell <tridge@samba.org>

(just FWIW)

-Eric

