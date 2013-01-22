Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:45912 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3AVSA5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 13:00:57 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122180057.FOZT17456.eastrmfepo201.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 13:00:57 -0500
Message-ID: <50FED3D8.1080208@czarc.net>
Date: Tue, 22 Jan 2013 13:00:56 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/13] btrfs-show-super.c
References: <1358715858-4469-1-git-send-email-gene@czarc.net> <1358715858-4469-7-git-send-email-gene@czarc.net> <20130121164628.GK19967@twin.jikos.cz>
In-Reply-To: <20130121164628.GK19967@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2013 11:46 AM, David Sterba wrote:
> On Sun, Jan 20, 2013 at 04:04:11PM -0500, Gene Czarcinski wrote:
>> remove extra blank line at EOF
> The patch contents and description do not match.
First of all, this patch should have been 2 separate patches. Too late 
to fix that.

The patch which created btrfs-show-super.c had an extra line at the end 
and I got annoyed at git-am complaining about it.  This first patch 
fixes that.  This should have been a separate commit.

The other patch (which should have been its own commit) addresses this 
problem:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg19264.html

I could not see that it did any harm and it helped on at least one 
system type

I am not sure how it happened that I combined them.  If you want, I will 
resubmit them the way it should be ... two separate patches with two 
separate commits.

Gene
>
>> --- a/man/Makefile
>> +++ b/man/Makefile
>> @@ -1,4 +1,4 @@
>> -GZIP=gzip
>> +GZIPCMD=gzip
> I'm not sure if this change is needed, does it stick to some well-known
> or established style in makefiles?
>
> david
>
>

