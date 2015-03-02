Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15258 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbbCBVto (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 16:49:44 -0500
Message-ID: <54F4DAEF.4080604@fb.com>
Date: Mon, 2 Mar 2015 16:49:35 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/7] btrfs: Check qgroup level in kernel qgroup assign.
References: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com> <1425025468-29749-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025468-29749-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2015 03:24 AM, Qu Wenruo wrote:
> Although we have qgroup level check in btrfs-progs, it's not enough
> since other programe may still call ioctl directly not using
> btrfs-progs. For example, systemd.
>
> But it's btrfs-progs to be blame since we don't provide a
> full-function(like subvolume create things) btrfs library with enough
> check, and only rely on kernel ioctl.
>
> So Add level checks in kernel too.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
