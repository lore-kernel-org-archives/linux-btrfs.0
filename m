Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5088 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751837AbaI3OZr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 10:25:47 -0400
Date: Tue, 30 Sep 2014 10:23:40 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH RFC] btrfs: introduce procfs interface for the device
 list
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1412087020.14485.0@mail.thefacebook.com>
In-Reply-To: <1411967340-23802-1-git-send-email-anand.jain@oracle.com>
References: <1411967340-23802-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, Sep 29, 2014 at 1:09 AM, Anand Jain <anand.jain@oracle.com> 
wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> (added RFC prefix to the patch header)
> (as of now just an experimental interface)
> 
> This patch introduces profs interface /proc/fs/btrfs/devlist,
> which as of now exports all the members of kernel fs_devices.
> 
> The current /sys/fs/btrfs interface works when the fs is
> mounted, and is on the file directory hierarchy and also has
> the sysfs limitation max output of U64 per file.
> 
> Here btrfs procfs uses seq_file to export all the members of
> fs_devices. Also shows the contents when device is not mounted,
> but have registered with btrfs kernel (useful as an alternative
> to buggy ready ioctl)
> 
> An attempt is made to follow the some standard file format
> output such as ini. So that a simple warper python script will
> provide end user useful interfaces.
> 
> Further planning to add few more members to the interface such as
> group profile info. The long term idea is to make procfs
> interface a onestop btrfs application interface for the device and
> fs info from the kernel, where a simple python script can make
> use of it.

Hi Anand,

We're going to have a really hard time getting a new proc interface 
merged in, and after we've recently fixed up all (most?) of our sysfs 
races, I'd rather not have to do it all over again with /proc. I know 
the lack of a seq interface is a difficult compromise to make in sysfs, 
but at this point I think we're stuck with it.  Which specific part do 
you hope to improve by dumping more information out in a single file?

-chris



