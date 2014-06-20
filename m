Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5167 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753725AbaFTPfP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 11:35:15 -0400
Message-ID: <53A455DE.7020502@fb.com>
Date: Fri, 20 Jun 2014 11:40:14 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Anand Jain <Anand.Jain@oracle.com>,
        <linux-btrfs@vger.kernel.org>, <jeffm@suse.com>
Subject: Re: [PATCH 0/6 v2] update sysfs per btrfs device operations
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com> <20140620095318.GA1553@twin.jikos.cz>
In-Reply-To: <20140620095318.GA1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/20/2014 05:53 AM, David Sterba wrote:
> Hi Chris,
> 
> any reason why the patches 1-5 were not added to 3.16 queue?
> 
> On Tue, Jun 03, 2014 at 11:35:58AM +0800, Anand Jain wrote:
>>   btrfs: rename add_device_membership to btrfs_kobj_add_device
>>   btrfs: dev delete should remove sysfs entry
>>   btrfs: dev add should add its sysfs entry
>>   btrfs: dev replace should replace the sysfs entry
>>   btrfs: create sprout should rename fsid on the sysfs as well

A mistake on my part.  I had them in a different bundle and missed it
(sorry Anand).  Today's pull has the locking fixes and a few others,
I'll put these in a pull early next week.

Thanks guys,
Chris
