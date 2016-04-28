Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15230 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbcD1OWd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 10:22:33 -0400
Subject: Re: [PATCH RFC 06/16] btrfs-progs: fsck: Introduce function to check
 referencer for data backref
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1461642543-4621-7-git-send-email-quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <bcfb9444-b620-312a-3b42-76a87d159f46@fb.com>
Date: Thu, 28 Apr 2016 10:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <1461642543-4621-7-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2016 11:48 PM, Qu Wenruo wrote:
> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
> Introduce new function check_extent_data_backref() to search referencer
> for a given data backref.
>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
