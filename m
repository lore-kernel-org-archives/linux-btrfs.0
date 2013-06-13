Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3FMEoz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 00:44:55 -0400
Message-ID: <51B94E47.1070900@redhat.com>
Date: Wed, 12 Jun 2013 23:44:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs and btrfs code similar why ?
References: <51B942E3.8000701@oracle.com>
In-Reply-To: <51B942E3.8000701@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/12/13 10:56 PM, Anand Jain wrote:
> 
> 
>   Per wiki an idea seems to maintain same code (probably
>   as much as possible) between btrfs-progs and btrfs
> 
>   There must have been a/few critical advantage, but
>   what are they ?
> 
> Thanks, Anand

Because they work with the same on-disk structures, and need
to perform many of the same tasks.  So using the same code base
means bugs get fixed once, features get written once, there is
built-in consistency, more coverage, etc.

I was just looking at an ext4 bug tonight where offline vs.
online resize result in different filesystem images.  In one
case it leads to a bug, in the other it doesn't.  The complex
resize code is implemented twice, and implemented differently.

Less code is good.  Consistency is good.

-Eric
