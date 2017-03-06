Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39347 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752926AbdCFR53 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Mar 2017 12:57:29 -0500
Subject: Re: [PATCH 0/9 PULL REQUEST] Qgroup fixes for 4.11
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <c11675d5-dd41-955c-06d0-db8aea1c7331@cn.fujitsu.com>
 <20170306164448.GO4662@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <8084eb83-7dc5-95b2-0eed-238add235739@fb.com>
Date: Mon, 6 Mar 2017 12:56:13 -0500
MIME-Version: 1.0
In-Reply-To: <20170306164448.GO4662@suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/06/2017 11:44 AM, David Sterba wrote:
> On Mon, Mar 06, 2017 at 04:08:41PM +0800, Qu Wenruo wrote:
>> Any response?
>>
>> These patches are already here for at least 2 kernel releases.
>> And are all bug fixes, and fix bugs that are already reported.
>>
>> I didn't see any reason why it should be delayed for so long time.
>
> The reason is not enough review for the whole series. The delay is
> unfortunate, same as almost zero people capable & willing to review it,
> despite your efforts to keep the series up to date with current code.
>

I've been hesitated to take more series of qgroup fixes because past 
sets have ended up causing problems down the line.  I'm queuing it for 
v4.12 while I collect tests and reviews though, it's definitely not fair 
for you to have to keep rebasing it without suggestions on what to fix.

Thanks!

-chris
