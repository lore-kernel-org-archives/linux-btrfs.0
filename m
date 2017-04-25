Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37050 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176348AbdDYJ0H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 05:26:07 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: compressing nocow files
To: Duncan <1i5t5.duncan@cox.net>
References: <CAJCQCtTnjNqhSNa9TypsJqvnKeh6H9dKJ9VU8_CHPuzu+zNxsA@mail.gmail.com>
 <20170417180707.GA3856@lim.localdomain>
 <pan$2f715$fa21b851$469190a7$153eb3a4@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <8e631633-f7a3-8e72-2d84-bcc95c2243e4@oracle.com>
Date: Tue, 25 Apr 2017 17:31:33 +0800
MIME-Version: 1.0
In-Reply-To: <pan$2f715$fa21b851$469190a7$153eb3a4@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> My question is, what does it do then when a new modification-write comes
> in to the compressed no-cow file, and the modification isn't as
> compressible as the data it replaced?

If any extent that is attempted to compress is found not compressible 
then it would mark inode as no-compress. Then inodes with no-compress 
flag will never attempt to compress its future COW extents. However if a 
use case expects future extents may be compressible then force-compress 
option will help, where each COW extent will be attempted to compress 
and holds compressed data only if there is a compression benefit.

HTH

Anand


