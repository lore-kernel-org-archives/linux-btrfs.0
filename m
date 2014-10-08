Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:48263 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbaJHQWM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Oct 2014 12:22:12 -0400
Message-ID: <543562C6.3030604@shroop.net>
Date: Wed, 08 Oct 2014 09:13:58 -0700
From: Rich Rauenzahn <rich@shroop.net>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Rich Rauenzahn <rrauenza@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Two uncorrectable errors across RAID1 at same logical block?
References: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com> <20141007020538.GA3187@localhost.localdomain> <54334D5E.9000300@shroop.net> <20141008142030.GA13823@localhost.localdomain>
In-Reply-To: <20141008142030.GA13823@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/8/2014 7:20 AM, Liu Bo wrote:
> On Mon, Oct 06, 2014 at 07:18:06PM -0700, Rich Rauenzahn wrote:
>> On 10/6/2014 7:05 PM, Liu Bo wrote:
>>> btrfs inspect-internal logical-resolve 58464632832
>> $  sudo btrfs inspect-internal logical-resolve 58464632832  /
>>
>> ...no output?
>>
>>
> Hmm...have you tried the latest btrfs-progs?
>
> You can pull it or get a tar ball from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>
> thanks,
> -liubo
>

Still no output:

   $ sudo ./btrfs inspect-internal logical-resolve 58464632832  /

Could it be a deleted file?


