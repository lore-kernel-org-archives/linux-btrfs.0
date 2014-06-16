Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34451 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043AbaFPRvw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 13:51:52 -0400
Message-ID: <539F2FEA.1060809@fb.com>
Date: Mon, 16 Jun 2014 13:56:58 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com>
In-Reply-To: <539E9026.1020406@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
> 

Did we recover, or was it stuck forever?

-chris
