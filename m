Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:41228 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbaJGC0V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 22:26:21 -0400
Message-ID: <54334D5E.9000300@shroop.net>
Date: Mon, 06 Oct 2014 19:18:06 -0700
From: Rich Rauenzahn <rich@shroop.net>
MIME-Version: 1.0
To: bo.li.liu@oracle.com, Rich Rauenzahn <rrauenza@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Two uncorrectable errors across RAID1 at same logical block?
References: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com> <20141007020538.GA3187@localhost.localdomain>
In-Reply-To: <20141007020538.GA3187@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/6/2014 7:05 PM, Liu Bo wrote:
> btrfs inspect-internal logical-resolve 58464632832

$  sudo btrfs inspect-internal logical-resolve 58464632832  /

...no output?


