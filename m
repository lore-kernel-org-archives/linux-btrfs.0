Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45323 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538AbaJQTdP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 15:33:15 -0400
Message-ID: <54416EF6.1050403@fb.com>
Date: Fri, 17 Oct 2014 15:33:10 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>, LKML <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs soft lockups: locks gone crazy
References: <1413271664.27233.13.camel@linux-t7sj.site>
In-Reply-To: <1413271664.27233.13.camel@linux-t7sj.site>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/14/2014 03:27 AM, Davidlohr Bueso wrote:
> Hello,
>
> I'm getting massive amounts of cpu soft lockups in Linus's tree for
> today. This occurs almost immediately and is very reproducible in aim7
> disk workloads using btrfs:
>

I'm trying to reproduce but it's not popping for me.  What is the setup 
of your fs?  mkfs options, mount options etc.  And how are you running 
aim7?  I'm using reaim with the default reaim.config and workfile,disk, 
is this what you are using?  If not please attach your config and 
workfile so I can be sure to be doing the same thing as you.  Thanks,

Josef

