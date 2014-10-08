Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37985 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbaJHOUq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Oct 2014 10:20:46 -0400
Date: Wed, 8 Oct 2014 22:20:31 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Rich Rauenzahn <rich@shroop.net>
Cc: Rich Rauenzahn <rrauenza@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Two uncorrectable errors across RAID1 at same logical block?
Message-ID: <20141008142030.GA13823@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com>
 <20141007020538.GA3187@localhost.localdomain>
 <54334D5E.9000300@shroop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54334D5E.9000300@shroop.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 06, 2014 at 07:18:06PM -0700, Rich Rauenzahn wrote:
> On 10/6/2014 7:05 PM, Liu Bo wrote:
> >btrfs inspect-internal logical-resolve 58464632832
> 
> $  sudo btrfs inspect-internal logical-resolve 58464632832  /
> 
> ...no output?
> 
> 

Hmm...have you tried the latest btrfs-progs?

You can pull it or get a tar ball from

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

thanks,
-liubo
