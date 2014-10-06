Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57287 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbaJFN0t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 09:26:49 -0400
Date: Mon, 6 Oct 2014 09:26:39 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: Make btrfs handle security mount options
 internally to avoid losing security label.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: Eric Sandeen <sandeen@redhat.com>, <linux-btrfs@vger.kernel.org>,
        <guaneryu@gmail.com>
Message-ID: <1412601999.31886.2@mail.thefacebook.com>
In-Reply-To: <54320637.4030506@cn.fujitsu.com>
References: <54320637.4030506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 5, 2014 at 11:02 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
wrote:
> 
>> 
>> I don't think that my "wish" should disallow your patch.
>> 
>> For the problem I was looking at, I think the only way forward would 
>> require
>> some significant selinux modification, and treating a subvol root 
>> essentially
>> like a superblock.
>> 
>> So ... don't let me slow you down, at least for now.  ;)
>> 
>> -Eric
>> 
> To Chris, any other comment?

It looks good to me, and I have it queued up here in testing.

-chris



