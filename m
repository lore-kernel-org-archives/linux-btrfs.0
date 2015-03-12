Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39834 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbbCLCwI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Mar 2015 22:52:08 -0400
Message-ID: <5500FF4C.2020702@oracle.com>
Date: Wed, 11 Mar 2015 22:51:56 -0400
From: Sasha Levin <sasha.levin@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: jbacik@fb.com, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: btrfs: kernel BUG at fs/btrfs/extent_io.c:676!
References: <543B35D3.6050509@oracle.com> <1413268312.2971.1@mail.thefacebook.com>
In-Reply-To: <1413268312.2971.1@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/14/2014 02:31 AM, Chris Mason wrote:
> On Sun, Oct 12, 2014 at 10:15 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Ping?
>>
>> This BUG_ON()ing due to GFP_ATOMIC allocation failure is really silly :(
> 
> Agreed, I have a patch for this in testing.  It didn't make my first pull but I'll get it fixed up.

I've re-enabled fs testing after the discussion at LSF/MM (but mostly
due to Michal's patch), and this issue came right back up.

Any updates?


Thanks,
Sasha
