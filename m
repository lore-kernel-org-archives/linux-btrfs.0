Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59806 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934792AbaKNXrl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 18:47:41 -0500
Date: Fri, 14 Nov 2014 18:47:34 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: soft lockup - CPU#0 stuck - Kernel 3.17.2
To: Patrick Schmid <schmid@phys.ethz.ch>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1416008854.25389.12@mail.thefacebook.com>
In-Reply-To: <1415989860.25389.11@mail.thefacebook.com>
References: <5464B2DB.7070008@phys.ethz.ch>
	<1415890157.25389.3@mail.thefacebook.com> <54650166.1090800@phys.ethz.ch>
	<1415905935.25389.4@mail.thefacebook.com> <54659FDB.6070300@phys.ethz.ch>
	<1415986775.25389.10@mail.thefacebook.com> <54664884.9010307@phys.ethz.ch>
	<1415989860.25389.11@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Nov 14, 2014 at 1:31 PM, Chris Mason <clm@fb.com> wrote:
> 
> 
> On Fri, Nov 14, 2014 at 1:23 PM, Patrick Schmid <schmid@phys.ethz.ch> 
> wrote:
>> 
>>> What kind of machine is this?  I'm trying to reproduce here.
>> 
>> The "frontend" hardware is a 24 core Xeon E5-2620 on an Intel 
>> S2600GZ board with 128 GiB RAM, the nic is a Intel X520-DA2 10Gb/s 
>> SFP+, running Ubuntu 14.04LTS.
>> 
>> Do you need more infos?
> 
> No, I think I see the problem.  I'm testing a patch here and I'll 
> send it later tonight.
> 

Ok, I think this is related to the new fair read/writer lock 
implementation in the generic kernel code.  btrfs_clear_path_blocking() 
will end up taking locks outside of the strict locking order the rest 
of Btrfs uses.  This used to be fine because we hold the blocking lock 
while we do it, but with the new queued locks we're running into 
trouble.  We hit a similar bug earlier and I convinced myself the 
problem was only with btrfs_next_leaf and our trylock.  But it's a 
bigger problem than I realized.

So for now I've changed btrfs_clear_path_blocking to honor the rules 
and fixed up our trylock to make it faster.

I'm letting a test run on this patch over the weekend, since I don't 
want any surprises with your backup farm.

-chris



