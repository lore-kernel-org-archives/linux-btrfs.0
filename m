Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab3DCQSP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Apr 2013 12:18:15 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r33GIEok030896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Apr 2013 12:18:14 -0400
Message-ID: <515C5644.30705@redhat.com>
Date: Wed, 03 Apr 2013 11:18:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: abort unlink trans in missed error case
References: <1364936536-13130-1-git-send-email-zab@redhat.com> <515C3E50.60807@redhat.com> <20130403160418.GG2850@lenny.home.zabbo.net>
In-Reply-To: <20130403160418.GG2850@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/3/13 11:04 AM, Zach Brown wrote:
>>
>> I was wondering if the transaction support should just be in the
>> err: goto case, and went looking.
> 
> Yeah, it's tempting. In the end I decided against it because this
> shouldn't be so willing to freak out and make the file system read only.
> It should try and undo the partial unlink and if *that* fails it should
> go read only. I went for the minimal fix for now.
> 
>> I'm not familiar enough with this stuff yet, but what if i.e.
>> btrfs_delete_one_dir_name fails, should that also abort the
>> transaction?
> 
> It doesn't abort because its the first thing that can fail.  It can
> cleanly return an error without leaving partial state around.
> 
> - z
> 

Oh, sure.  thanks - 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
