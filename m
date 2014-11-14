Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35224 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161463AbaKNSbH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 13:31:07 -0500
Date: Fri, 14 Nov 2014 13:31:00 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: soft lockup - CPU#0 stuck - Kernel 3.17.2
To: Patrick Schmid <schmid@phys.ethz.ch>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1415989860.25389.11@mail.thefacebook.com>
In-Reply-To: <54664884.9010307@phys.ethz.ch>
References: <5464B2DB.7070008@phys.ethz.ch>
	<1415890157.25389.3@mail.thefacebook.com> <54650166.1090800@phys.ethz.ch>
	<1415905935.25389.4@mail.thefacebook.com> <54659FDB.6070300@phys.ethz.ch>
	<1415986775.25389.10@mail.thefacebook.com> <54664884.9010307@phys.ethz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Nov 14, 2014 at 1:23 PM, Patrick Schmid <schmid@phys.ethz.ch> 
wrote:
> 
>> What kind of machine is this?  I'm trying to reproduce here.
> 
> The "frontend" hardware is a 24 core Xeon E5-2620 on an Intel S2600GZ 
> board with 128 GiB RAM, the nic is a Intel X520-DA2 10Gb/s SFP+, 
> running Ubuntu 14.04LTS.
> 
> Do you need more infos?

No, I think I see the problem.  I'm testing a patch here and I'll send 
it later tonight.

Thanks!

-chris



