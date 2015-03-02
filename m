Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28934 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205AbbCBWFj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 17:05:39 -0500
Message-ID: <54F4DEAC.9000307@fb.com>
Date: Mon, 2 Mar 2015 17:05:32 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/9] btrfs: qgroup: move WARN_ON() to the correct location.
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1423563803-8996-3-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-3-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2015 05:23 AM, Dongsheng Yang wrote:
> In function qgroup_excl_accounting(), we need to WARN when
> qg->excl is less than what we want to free, same to child
> and parents. But currently, for parent qgroup, the WARN_ON()
> is located after freeing qg->excl. It will WARN out even we
> free it normally.
>
> This patch move this WARN_ON() before freeing qg->excl.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
