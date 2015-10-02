Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24544 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbbJBJuS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 05:50:18 -0400
Message-ID: <560E5096.7050903@oracle.com>
Date: Fri, 02 Oct 2015 17:38:30 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: dsterba@suse.cz
Subject: Re: [PATCH 1/1] Btrfs: consolidate btrfs_error() to btrfs_std_error()
References: <1443163381-12332-1-git-send-email-anand.jain@oracle.com> <20150925103128.GC11442@twin.jikos.cz> <560E3510.1070403@oracle.com> <560E40E5.1000602@gmx.com>
In-Reply-To: <560E40E5.1000602@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> It only needs to log an error, no need to mark FS_ERROR bit.
> As it may just be an invalid parameter.

  This ans-ed my question. Then there are two bugs. one which David
  pointed out. two In original code (before this patch), it should
  have been calling btrfs_err() instead of btrfs_error().

Thanks, Anand
