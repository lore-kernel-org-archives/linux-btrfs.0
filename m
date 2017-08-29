Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23796 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbdH2B4s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 21:56:48 -0400
Subject: Re: [PATCH 0/1] btrfs-progs: mkfs: add subvolume support to mkfs
To: Yingyi Luo <yingyil@google.com>, linux-btrfs@vger.kernel.org
References: <20170825232101.10859-1-yingyil@google.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0cb3bdf8-6bcb-290e-86bc-92c3fcd8b441@oracle.com>
Date: Tue, 29 Aug 2017 10:04:08 +0800
MIME-Version: 1.0
In-Reply-To: <20170825232101.10859-1-yingyil@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Add -S/--subvol [NAME] option to configure. It enables users to create a
> subvolume under the toplevel volume 

 > and populate the created subvolume
 > with files from the rootdir specified by -r/--rootdir option.

  This brings two enhancements, those might be good ideas, but stating a 
specific use case will add the required clarity.

Thanks, Anand
