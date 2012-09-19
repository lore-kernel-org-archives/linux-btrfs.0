Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:47732 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2ISBwu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 21:52:50 -0400
Message-ID: <50592607.709@oracle.com>
Date: Wed, 19 Sep 2012 09:55:19 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 4/7] Btrfs-progs: fix wrong way to check if the root
 item contains otime and uuid
References: <50584E6D.8000602@cn.fujitsu.com> <50585420.6060407@cn.fujitsu.com>
In-Reply-To: <50585420.6060407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Miao,

> wrong because it is possbile that ->generation may equal to the first
> variant of the next item.

  When can this happen ?  Can you provide a scenario to run through. ?

Thanks, Anand
