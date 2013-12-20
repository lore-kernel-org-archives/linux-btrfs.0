Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33350 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161017Ab3LTNbD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 08:31:03 -0500
Message-ID: <52B44688.5070603@fb.com>
Date: Fri, 20 Dec 2013 05:30:48 -0800
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 00/18] Replace btrfs_workers with kernel workqueue
 based btrfs_workqueue
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com> <52B3105A.5000102@fb.com> <52B3B4BC.70204@cn.fujitsu.com>
In-Reply-To: <52B3B4BC.70204@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/19/2013 07:08 PM, Qu Wenruo wrote:
> I'm sorry but I failed to reproduce the problem.
> Btrfs/012 in xfstests has been run for serveral hours but nothing 
> happened.
>
> Would you please give me some more details about the environment or 
> the panic backtrace?
>

Ok so it wasn't that test, it was just ./check -g auto.  It would 
sometimes die at btrfs/012, other times it would make it as far as 
generic/083 before it keeled over.  I bisected it down to

btrfs: Replace fs_info->workers with btrfs_workqueue

which of course is just the first patch that you start using the new 
code which isn't helpful.  My dmesg from one of my runs is here

http://ur1.ca/g867b

All of the initial panics looked exactly the same.  I'm just going to 
kick the series out for now while you track down the problem. Thanks,

Josef
