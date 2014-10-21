Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:36811 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbaJUPXe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 11:23:34 -0400
Message-ID: <54467A73.5030804@pobox.com>
Date: Tue, 21 Oct 2014 08:23:31 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: russell@coker.com.au, linux-btrfs@vger.kernel.org
Subject: Re: strange 3.16.3 problem (er... never mind 8-)
References: <201410181454.19375.russell@coker.com.au> <20141020130243.GB29401@hungrycats.org> <201410212113.30887.russell@coker.com.au> <201410212142.22754.russell@coker.com.au>
In-Reply-To: <201410212142.22754.russell@coker.com.au>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/2014 03:42 AM, Russell Coker wrote:
> I've just upgraded the Dom0 (NFS server) from 3.16.3 to 3.16.5 and it all
> works.
>
> Prior to upgrading the Dom0 I had the same problem occur with different file
> names.  All the names in question were truncated names of files that exist.
> It seems that 3.16.3 has a bug with NFS serving files with long names.
>
> Thanks for all the suggestions.
>

Well never mind my message from a few minutes ago...

But thanks for finding that problem/solution. I've been having an NFS 
problem of my own and it is from a server running 3.16.3... so you may 
have just made my day. 8-)
