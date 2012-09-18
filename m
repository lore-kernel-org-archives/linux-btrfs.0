Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44908 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2IRFy2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 01:54:28 -0400
Message-ID: <50580D1C.9020303@oracle.com>
Date: Tue, 18 Sep 2012 13:56:44 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 4/7] Btrfs-progs: fix wrong way to check if the root
 item contains otime and uuid
References: <50487FD8.1000804@cn.fujitsu.com>
In-Reply-To: <50487FD8.1000804@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -				if(ri->generation == ri->generation_v2) {
> +				if(sh->len == sizeof(struct btrfs_root_item)) {
>   					t = ri->otime.sec;

  This looks fine now but should this work when we
  move to v3 and still have access to v2 introduced
  members.?

  ker cli
  v3  v2  v2 introduced members are unnecessarily blocked
  v2  v3  --as above--

Thanks, Anand
