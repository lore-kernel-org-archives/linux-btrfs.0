Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6559 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038AbaJNGcE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 02:32:04 -0400
Date: Tue, 14 Oct 2014 02:31:52 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: btrfs: kernel BUG at fs/btrfs/extent_io.c:676!
To: Sasha Levin <sasha.levin@oracle.com>
CC: <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Message-ID: <1413268312.2971.1@mail.thefacebook.com>
In-Reply-To: <543B35D3.6050509@oracle.com>
References: <543B35D3.6050509@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 12, 2014 at 10:15 PM, Sasha Levin <sasha.levin@oracle.com> 
wrote:
> Ping?
> 
> This BUG_ON()ing due to GFP_ATOMIC allocation failure is really silly 
> :(

Agreed, I have a patch for this in testing.  It didn't make my first 
pull but I'll get it fixed up.

-chris


