From: Mikhail Raskin <raskin@mccme.ru>
Subject: Re: Mass-Hardlinking Oops
Date: Tue, 4 Aug 2009 00:01:20 +0400 (MSD)
Message-ID: <20090803235920.C13173@mccme.ru>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
 <4A76FB78.5000207@wpkg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A76FB78.5000207@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 3 Aug 2009, Tomasz Chmielewski wrote:
> Chris Mason wrote:
>> As Yan said on IRC there's a limit to the number of hardlinks per file
>> in a given directory.  We clearly need to change this from BUG() to
>> return a nice error.
> BTW, what limit is that?
272 links. Creating 273-th link causes BUG(). The limit seems so arbitrary 
that it maybe can be made higher.. 32-bit (billions of links) seem totally 
unrestrictive..
