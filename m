Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbcFXDWI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 23:22:08 -0400
Subject: Re: btrfs-progs 4.6 won't build on CentOS6
To: Steven Haigh <netwiz@crc.id.au>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3864856543476b0f69224f6b6be3ed26@crc.id.au>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <d08ce5a1-d74f-40be-54ae-4cadb56fd391@redhat.com>
Date: Thu, 23 Jun 2016 22:22:06 -0500
MIME-Version: 1.0
In-Reply-To: <3864856543476b0f69224f6b6be3ed26@crc.id.au>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/23/16 8:49 PM, Steven Haigh wrote:
> I've tried to build the new tools for CentOS 6 / Scientific Linux 6 / RHEL 6 etc.
> 
> During the build process, I see:
> cmds-fi-du.c: In function 'du_calc_file_space':
> cmds-fi-du.c:330: error: 'FIEMAP_EXTENT_SHARED' undeclared (first use in this function)
> cmds-fi-du.c:330: error: (Each undeclared identifier is reported only once
> cmds-fi-du.c:330: error: for each function it appears in.)
> make: *** [cmds-fi-du.o] Error 1
> 
> I'm guessing this is probably due to a different GCC version used? I'm guessing this is a simple fix for someone with knowhow... :)

Fair warning, the btrfs.ko in centos6 is positively ancient, and it
won't be updated.

Just in case that matters to you ... not sure if you just want to
build there, or use actually btrfs under a centos6 kernel....

-Eric

