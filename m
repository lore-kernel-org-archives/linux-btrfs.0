Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gourmet.spamgourmet.com ([216.75.62.102]:47271 "EHLO
	gourmet8.spamgourmet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934528AbbKSSpR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 13:45:17 -0500
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <linux-btrfs.tebulin@xoxy.net>)
	id 1ZzUCq-0001jN-UE
	for linux-btrfs@vger.kernel.org; Thu, 19 Nov 2015 18:45:16 +0000
From: linux-btrfs.tebulin@xoxy.net
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk> <564E085C.3060208@gmail.com>
 <20151119182850.GE24333@carfax.org.uk>
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Message-ID: <564E18B9.2020509@gmail.com>
Date: Thu, 19 Nov 2015 19:45:13 +0100
MIME-Version: 1.0
In-Reply-To: <20151119182850.GE24333@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>    It's just freed up lots of space. You'll probably find that your
> "total" value for data in btrfs fi df is close to (but not exactly) 66
> GiB now, if you've just run a full unfiltered balance. (The difference
> being made up of metadata).

I think i need to dive more into the details of btrfs to finally grasp
the details here

>    There's a repo of "useful btrfs scripts" that David Sterba looks
> after. 

Great pointer!
I think you refer to https://github.com/kdave/btrfsmaintenance and it
indeed looks very promising.

>> Should I pick "btrfs show" in favor to "btrfs fi df" to learn about an impending "disk full" situation?  
>    In the general case, you need both of them to make sense of it. 

Duh.... I'll better... ehh... try to find some backported btrfs-profs
supporting `usage`.

>> Will newer kernels do the balance on their own? 
>    I think it's on the "projects" list on the wiki [..]  aware of anyone working on it.

Ok - which is another +1 for looking at David 's repo.

Thanks!
- Ben

