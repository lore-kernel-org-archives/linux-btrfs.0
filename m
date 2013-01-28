Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:50674 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3A1V66 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 16:58:58 -0500
Message-ID: <5106F48C.3050600@sandia.gov>
Date: Mon, 28 Jan 2013 14:58:36 -0700
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: "Josef Bacik" <jbacik@fusionio.com>
cc: "Liu Bo" <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
In-Reply-To: <20130128212331.GG3257@localhost.localdomain>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/28/2013 02:23 PM, Josef Bacik wrote:
> On Thu, Jan 03, 2013 at 11:44:46AM -0700, Jim Schutt wrote:
>> Hi Josef,
>>
>> Thanks for the patch - sorry for the long delay in testing...
>>
> 
> Jim,
> 
> I've been trying to reason out how this happens, could you do a btrfs fi df on
> the filesystem thats giving you trouble so I can see if what I think is
> happening is what's actually happening.  Thanks,

Sure - it'll take me a bit to set the test up again.

-- Jim

> 
> Josef
> 
> 


