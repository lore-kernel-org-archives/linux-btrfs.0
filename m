Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:54120 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3HZGmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 02:42:55 -0400
Message-ID: <521AF8E4.80405@jan-o-sch.net>
Date: Mon, 26 Aug 2013 08:42:44 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Thomas Koch <thomas@koch.ro>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: check for reflink capability and for shared data
References: <201308241809.58701.thomas@koch.ro> <20130824162013.GL3115@carfax.org.uk>
In-Reply-To: <20130824162013.GL3115@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
On Sat, August 24, 2013 at 18:20 (+0200), Hugo Mills wrote:
> On Sat, Aug 24, 2013 at 06:09:58PM +0200, Thomas Koch wrote:
>> Hi,
>>
>> how can I do the following in a shell script:
>>
>> - check whether my file system supports cp --reflink?
> 
> touch foo; if cp --reflink=always foo bar; then ...; fi; rm -f foo bar
> 
>> - check whether two files share the same data on disk, i.e. one has been 
>> created by cp --reflink of the other?
> 
>    You can't, using simple userspace tools. I think the only way would
> be to use the tree search ioctl to inspect the extents for each file,
> and see whether any of them overlap. Why do you need to know this?

It should work with fiemap to a file in question and btrfs inspect logical to
what ever extents fiemap reported as "physical".

-Jan
