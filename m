Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:56569 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab3BCRl7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Feb 2013 12:41:59 -0500
Date: Sun, 3 Feb 2013 12:41:56 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: "kreijack@inwind.it" <kreijack@inwind.it>,
        Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: include kerncompat.h in raid6.c, define
 __attribute_const__
Message-ID: <20130203174156.GA25685@shiny>
References: <510D7356.4030903@inwind.it>
 <510E8898.4050606@redhat.com>
 <20130203170138.GC16594@twin.jikos.cz>
 <510E9FA3.5060600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <510E9FA3.5060600@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 03, 2013 at 10:34:27AM -0700, Eric Sandeen wrote:
> raid6.c was failing to build for Goffredo and me due to
> __attribute_const__ being undefined.

Thanks, I've pushed this along with an extra #ifndef into the raid56
experimental branch.

-chris
