From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 03 Aug 2009 17:00:08 +0200
Message-ID: <4A76FB78.5000207@wpkg.org>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Raskin Michael <raskin@mccme.ru>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090803145741.GC3765@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Sat, Aug 01, 2009 at 05:16:11PM +0400, Raskin Michael wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> This is distinct from the old mass-symlinking warnings. I run a program
>> which promised to hardlink all the same-content files on the partition.
>> The failure occured reasonably quickly...
> 
> As Yan said on IRC there's a limit to the number of hardlinks per file
> in a given directory.  We clearly need to change this from BUG() to
> return a nice error.

BTW, what limit is that?


-- 
Tomasz Chmielewski
http://wpkg.org
