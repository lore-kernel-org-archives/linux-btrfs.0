Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:40049 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3FZKDl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 06:03:41 -0400
Message-ID: <1372240988.5177.20.camel@miguel-MacBookPro>
Subject: Re: btrfs send/receive issues
From: Miguel =?ISO-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 26 Jun 2013 11:03:08 +0100
In-Reply-To: <20130624162139.GI4288@localhost.localdomain>
References: <1372027293.1052.12.camel@miguel-MacBookPro>
	 <20130624162139.GI4288@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Mon, 2013-06-24 às 12:21 -0400, Josef Bacik escreveu:
> I'm not sure, I just did it and it worked fine for me.  Could you file a
> bugzilla at bugzilla.kernel.org and make sure the component is set to btrfs?
> Also could you do the send to a file, and then receive from the file so we can
> see if its send or receive that's giving you the error and put that in the
> bugzilla?  Thanks

I've added the bug at https://bugzilla.kernel.org/show_bug.cgi?id=60081

The problem it's on the receiving side, I can create the two files but
then I can't "btrfs receive" the second file, I get the error that it
can't find the directory. I've placed the two files I used for testing
on the bug report, so you can try btrfs receive on them.

thanks,
-- 
Miguel Negrão
http://www.friendlyvirus.org/miguelnegrao


