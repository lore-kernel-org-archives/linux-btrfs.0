Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031447Ab3HIXZc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 19:25:32 -0400
Date: Sat, 10 Aug 2013 01:25:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 V2] btrfs-progs: mark static & remove unused from
 non-kernel code
Message-ID: <20130809232529.GO5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52019C6D.9050308@redhat.com>
 <52019D5F.3070301@redhat.com>
 <52054F1F.5000407@redhat.com>
 <20130809224854.GN5284@twin.jikos.cz>
 <5205784E.7030705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5205784E.7030705@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 09, 2013 at 06:16:30PM -0500, Eric Sandeen wrote:
> Ok, fair enough - so preferred is
> 
> <lots of type stuff> function(some args . . ,
>                               . . .  more args . . .,
>                               . . . last args)

Yeah something like that, bonus points if variable type and name are on
the same line.

> ?  sorry, old xfs habits die hard. ;)

sure, np ;)
